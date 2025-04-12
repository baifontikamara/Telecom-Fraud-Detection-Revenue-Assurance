# Telecom-Fraud-Detection-&-Revenue-Assurance

An AI-powered Telecom Fraud Detection and Revenue Assurance System.


# Project Setup & Execution
prerequisites:
- **Docker**: To run the system.
- **PostgreSQL**: To store and manage data.
- **Jupyter Notebook**: To execute Python scripts.
- **Python Packages**:
    - `pandas`
    - `numpy`
    -  `psycopg2`
    - `scikit-learn`
    - `lightgbm`


## Overview

This project implements a fraud detection and revenue assurance system for telecom companies using AI, machine learning, and data analytics. It consists of two main components:

1. **SQL-based Fraud Detection and Revenue Assurance Rules**: Implemented in `Docker_Postgre_SQLsession.sql`.
2. **Data Analytics and Model Training**: Implemented in `data_analytics_and_model_training.ipynb`.


The system is designed to identify fraudulent activities, ensure billing accuracy, and provide actionable insights for telecom companies.


---

## 1. SQL-Based Fraud Detection and Revenue Assurance (`Docker_Postgre_SQLsession.sql`)

This file contains SQL queries and views to detect fraud and ensure revenue assurance. Below is a breakdown of its functionality:

### Fraud Detection Rules:
- **High-Value Transfers**: Identifies transactions of type `TRANSFER` with amounts exceeding 200,000.
- **Inconsistent Balances**: Detects discrepancies in account balances that may indicate tampering.
- **False Positives**: Flags transactions marked as fraud (`is_flagged_fraud = TRUE`) but not actually fraudulent (`is_fraud = FALSE`).
- **Multiple Fraudulent Transactions**: Identifies accounts with three or more fraudulent transactions.
- **Suspiciously Round Amounts**: Flags transactions with round amounts like 50,000, 100,000, etc.

### Revenue Assurance Rules:
- **Mismatched Charges**: Compares actual charges with expected charges based on usage rates:
  - Day Rate: 0.10 per minute
  - Evening Rate: 0.05 per minute
  - Night Rate: 0.02 per minute
  - International Rate: 0.15 per minute
- **High Customer Service Callers**: Identifies customers with four or more customer service calls who are at risk of churn.
- **Ghost Charges**: Flags zero-minute calls that are still billed.
- **High International Charges Before Churn**: Identifies churned customers with high international charges.

### Views and Tables:
- **`view_high_value_frauds`**: A view for high-value transfers.
- **`view_inconsistent_balances`**: A view for transactions with inconsistent balances.
- **`view_billing_mismatches`**: A view for mismatched charges.
- **`fraud_summary` Table**: Stores all transactions flagged as fraudulent.
- **`billing_issues` Table**: Stores records of billing mismatches.

---

## 2. Data Analytics and Model Training (`data_analytics_and_model_training.ipynb`)

This Jupyter Notebook handles data preprocessing, machine learning model training, and analytics for fraud detection and revenue assurance.

### Key Steps:
1. **Data Loading**:
   - Loads `financial_transactions` and `customer_data_record` tables from PostgreSQL into Pandas DataFrames.

2. **Fraud Detection**:
   - Trains a machine learning model to predict fraudulent transactions using features like `transaction_type`, `amount`, `old_balance_org`, `new_balance_orig`, etc.
   - Flags predicted frauds and saves them to the `fraud_predictions` table in PostgreSQL.

3. **Revenue Assurance**:
   - Calculates expected charges for day, evening, night, and international calls using predefined rates.
   - Compares expected charges with actual charges to identify mismatches.
   - Saves billing issues to the `billing_issues` table in PostgreSQL.

4. **Insights and Reporting**:
   - Provides insights into fraud patterns and billing mismatches.
   - Outputs the number of mismatches and fraud predictions for further analysis.

### Key Variables:
- **Rates**:
  - `DAY_RATE = 0.10`
  - `EVE_RATE = 0.05`
  - `NIGHT_RATE = 0.02`
  - `INTL_RATE = 0.15`
- **DataFrames**:
  - `txn_df`: Contains financial transactions data.
  - `customer_df`: Contains customer data records.

---

## How the Project Works

1. **SQL Rules Execution**:
   - Run the queries in `Docker_Postgre_SQLsession.sql` to detect fraud and ensure billing accuracy.
   - Use the generated views and tables for further analysis.

2. **Data Analytics and Model Training**:
   - Execute the Jupyter Notebook `data_analytics_and_model_training.ipynb` to preprocess data, train the fraud detection model, and identify billing mismatches.
   - Save the results to PostgreSQL for reporting and auditing.

3. **Integration**:
   - The SQL rules and machine learning model complement each other to provide a comprehensive fraud detection and revenue assurance system.

---

## Purpose of the Project

The primary goal of this project is to help telecom companies:
- Detect and prevent fraudulent activities in financial transactions.
- Ensure accurate billing and minimize revenue leakage.
- Provide actionable insights to improve customer satisfaction and reduce churn.

By combining SQL-based rules with machine learning, the system offers a robust and scalable solution for telecom fraud detection and revenue assurance.

# System Benefits

**Fraud Prevention**

- Early detection of suspicious transactions
- Pattern recognition for fraudulent behavior
- Real-time monitoring capabilities

**Revenue Protection**
- Accurate billing verification
- Detection of charging anomalies
- Identification of revenue leakage

**Customer Experience**
- Prevention of overcharging
- Early churn risk detection
- Service quality monitoring

# Maintenance & Updates

- Regular model retraining recommended
- SQL rules can be modified for specific requirements
- Performance metrics should be monitored periodically

# Future Enhancements
- Real-time fraud detection integration
- Advanced feature engineering
- API development for external system integration
- Dashboard for visualization
- Automated alert system


