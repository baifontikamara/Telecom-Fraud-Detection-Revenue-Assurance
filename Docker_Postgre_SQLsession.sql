/**FRAUD DETECTION RULES (SQL-BASED)*/
-- This SQL script contains various queries to detect potential fraud in financial transactions.

--High-Value Transfers Over 200,000
-- This query retrieves high-value transfers over 200,000 from the transactions table.
SELECT *
FROM financial_transactions
WHERE transaction_type = 'TRANSFER'
  AND amount > 200000;

--Inconsistent Balances (Balance Tampering Suspected)
SELECT *
FROM financial_transactions
WHERE ABS((old_balance_org - amount) - new_balance_orig) > 1
   OR ABS((new_balance_dest - old_balance_dest) - amount) > 1;


--Transactions Marked as Flagged but NOT Actually Fraud, Manual review candidates (false positives)
SELECT *
FROM financial_transactions
WHERE is_flagged_fraud = TRUE AND is_fraud = FALSE;


--Multiple Fraudulent Transactions from Same Source Account
SELECT name_orig, COUNT(*) AS fraud_count
FROM financial_transactions
WHERE is_fraud = TRUE
GROUP BY name_orig
HAVING COUNT(*) >= 3;

--Suspiciously Round Amounts (e.g., 100000.00, 50000.00, etc.)
SELECT *
FROM financial_transactions
WHERE amount IN (50000, 100000, 200000, 500000);


--REVENUE ASSURANCE & BILLING ACCURACY (SQL)
/** This SQL script contains various queries to ensure revenue assurance and billing accuracy. **/

--Mismatched Charges vs. Expected (Under/Over-billing)
SELECT phone_number,
       day_mins, day_charge, ROUND((day_mins * 0.10)::numeric, 2) AS expected_day_charge,
       eve_mins, eve_charge, ROUND((eve_mins * 0.05)::numeric, 2) AS expected_eve_charge,
       night_mins, night_charge, ROUND((night_mins * 0.02)::numeric, 2) AS expected_night_charge,
       intl_mins, intl_charge, ROUND((intl_mins * 0.15)::numeric, 2) AS expected_intl_charge
FROM customer_data_record
WHERE ROUND((day_mins * 0.10)::numeric, 2) != day_charge
   OR ROUND((eve_mins * 0.05)::numeric, 2) != eve_charge
   OR ROUND((night_mins * 0.02)::numeric, 2) != night_charge
   OR ROUND((intl_mins * 0.15)::numeric, 2) != intl_charge;


--High Customer Service Callers at Risk of Churn
SELECT phone_number, custserv_calls, churn
FROM customer_data_record
WHERE custserv_calls >= 4 AND churn = TRUE;

--Zero-Minute Calls That Are Still Billed (Ghost Charges)
SELECT phone_number, day_mins, day_charge
FROM customer_data_record
WHERE day_mins = 0 AND day_charge > 0;

--Churned Customers with High Intl Charges Before Exit
SELECT *
FROM customer_data_record
WHERE churn = TRUE AND intl_charge > 50
ORDER BY intl_charge DESC;

--Save Insights into Audit Tables (Optional)
CREATE TABLE fraud_summary AS
SELECT * FROM financial_transactions
WHERE is_fraud = TRUE;

CREATE TABLE billing_issues AS
SELECT *
FROM customer_data_record
WHERE ROUND(CAST(day_mins * 0.10 AS numeric), 2) != day_charge
   OR ROUND(CAST(eve_mins * 0.05 AS numeric), 2) != eve_charge
   OR ROUND(CAST(night_mins * 0.02 AS numeric), 2) != night_charge
   OR ROUND(CAST(intl_mins * 0.15 AS numeric), 2) != intl_charge;

--view_high_value_frauds
CREATE OR REPLACE VIEW view_high_value_frauds AS
SELECT *
FROM financial_transactions
WHERE transaction_type = 'TRANSFER'
  AND amount > 200000;

  --view_inconsistent_balances
  CREATE OR REPLACE VIEW view_inconsistent_balances AS
SELECT *
FROM financial_transactions
WHERE ABS((old_balance_org - amount) - new_balance_orig) > 1
   OR ABS((new_balance_dest - old_balance_dest) - amount) > 1;

--view_billing_mismatches
CREATE OR REPLACE VIEW view_billing_mismatches AS
SELECT phone_number,
       day_charge, ROUND(CAST(day_mins * 0.10 AS NUMERIC), 2) AS expected_day_charge,
       eve_charge, ROUND(AST(eve_mins * 0.05 AS NUMERIC), 2) AS expected_eve_charge,
       night_charge, ROUND(AST(night_mins * 0.02 AS NUMERIC), 2) AS expected_night_charge,
       intl_charge, ROUND(AST(intl_mins * 0.15 AS NUMERIC), 2) AS expected_intl_charge
FROM customer_data_record
WHERE ROUND(AST(day_mins * 0.10 AS NUMERIC), 2) != day_charge
   OR ROUND(AST(eve_mins * 0.05 AS NUMERIC), 2) != eve_charge
   OR ROUND(AST(night_mins * 0.02 AS NUMERIC), 2) != night_charge
   OR ROUND(AST(intl_mins * 0.15 AS NUMERIC), 2) != intl_charge;
