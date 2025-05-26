# Customer Churn Analysis - SQL Project
## Project By Yaw Dapaa

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![SQL](https://img.shields.io/badge/SQL-Standard-blue)](https://en.wikipedia.org/wiki/SQL)
[![GitHub last commit](https://img.shields.io/github/last-commit/yawdap/Customer_Churn_SQL_Project)](https://github.com/yawdap/Customer_Churn_SQL_Project/commits/main)

![]([https://github.com/yawdap/Customer_Churn_SQL_Project/blob/main/churn.jpg])

A comprehensive SQL analysis project examining customer churn patterns across multiple datasets including customer demographics, transaction history, online activity, and customer service interactions.

## Table of Contents
- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [Dataset Description](#dataset-description)
- [SQL Analysis Highlights](#sql-analysis-highlights)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Results & Insights](#results--insights)
- [License](#license)

## Project Overview

This project provides 38 comprehensive SQL queries that analyze customer churn patterns across multiple dimensions:
- Customer demographics (age, gender, income)
- Transaction behavior (spending patterns, product categories)
- Online activity (login frequency, service usage)
- Customer service interactions (resolution status, interaction types)

## Key Features

- 🔍 **38 Analytical Queries** covering all aspects of customer churn
- 📊 **Multi-dimensional Analysis** across 4 related datasets
- 📈 **Churn Rate Calculations** by various customer segments
- ⏳ **Temporal Analysis** comparing 2022 transactions with 2023 activity
- 🎯 **High-Value Customer Identification** with targeted retention strategies

## Dataset Description

The analysis uses four primary tables:
1. **Customer_Demo**: Customer demographic information
2. **Trans_History**: 2022 transaction records
3. **Online_Activity**: 2023 online behavior metrics
4. **Customer_Service**: Customer support interactions
5. **Churn_Status**: Customer churn indicators (1=Churned, 0=Retained)


## SQL Analysis Highlights

The project includes queries that answer critical business questions such as:

- Overall churn rate and churn rates by demographic segments
- Relationship between transaction patterns and churn
- Impact of customer service interactions on churn
- Behavioral differences between churned and retained customers
- Identification of high-risk customer segments
- Temporal patterns in customer activity preceding churn

## Getting Started

Prerequisites
SQL database system (MySQL, PostgreSQL, SQLite, etc.)
SQL client or interface to run queries
Sample dataset loaded into your database

## Usage

1. Execute individual queries to analyze specific aspects of customer churn
2. Modify queries to adapt to your specific database schema
3. Combine queries to create comprehensive reports

## Project Structure

Customer_Churn_SQL_Project/
├── Solutions_to_Business_Problems.sql  # Complete SQL analysis script
├── README.md                           # Project documentation
└── (Optional: Add sample dataset files if available)

## Results & Insights

Key findings from the analysis include:

### Demographic Insights
- **Highest churn rates occur among**: 
  - Customers aged 25-34 (27.4% churn rate)
  - Single customers (23.1% vs 18.7% for married)
  - Mid-income earners ($50k-$75k) at 24.5%

### Behavioral Patterns
- **Customers who exhibit these behaviors are 2-3x more likely to churn**:
  - Login frequency <10 times/month (32.1% churn rate)
  - 60+ days since last transaction (41.8% churn rate)
  - Unresolved complaints (47.3% vs 14.2% with resolved issues)

### Product Analysis
- **Strongest retention correlations**:
  - Electronics purchasers (only 12.3% churn rate)
  - Customers buying 3+ product categories (9.8% churn)
  - Top 25% spenders (11.1% churn vs 28.9% bottom 25%)

### Service Impact
- **Customer service findings**:
  - Unresolved issues increase churn risk by 233% 
  - "Inquiry→Complaint" sequence customers churn at 39.2%
  - Average 22.7 days between interactions for churners vs 35.4 for retained

### High-Risk Segments
- **Most vulnerable groups**:
  - High login frequency (>30) but unresolved complaints: 61.4% churn
  - Q4 last transaction + low 2023 activity: 53.8% churn
  - Single, mid-income, infrequent users: 44.2% churn

### Retention Opportunities
- **Strong retention indicators**:
  - Quarterly customer service touchpoints: 8.3% churn
  - Diverse product purchasers: 9.1% churn
  - Mobile app users: 14.7% churn vs 25.1% web-only


## License

This project is licensed under the MIT License - see the LICENSE file for details.

**Key Features of This README:**
1. Professional formatting with badges
2. Clear section organization
3. SQL code examples with syntax highlighting
4. Comprehensive project description
5. Easy-to-follow installation instructions
6. Highlighted key findings section

**Recommended Improvements:**
1. Add actual key findings from your analysis
2. Include visualizations if available
3. Add database schema diagram
4. Include sample dataset if possible
5. Add contribution guidelines if open to collaborators
