# Brazilian Olist E-Commerce | SQL Data Analysis

## Project Overview

This project focuses on analyzing the Brazilian Olist E-Commerce dataset using MySQL to explore sales performance, customer behavior, seller efficiency, shipping operations, and payment trends.

The project involves data preparation, cleaning, transformation, and SQL-based analysis to address business questions and support data-driven decision-making.

## Project Objectives

- Analyze revenue performance across product categories.
- Examine monthly revenue trends and growth patterns.
- Explore customer purchasing behavior and segmentation.
- Evaluate seller performance and identify potential underperformers.
- Analyze geographical sales distribution and delivery efficiency.
- Understand payment preferences and installment behavior.
- Examine customer retention through monthly cohort analysis.

## Tools & Technologies

- **MySQL:** Data cleaning, transformation, and analysis
- **MySQL Workbench:** Database management and SQL query execution
- **SQL Techniques:** Joins, aggregations, subqueries/CTEs, window functions, date functions, and data type conversions

## Dataset Information

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

**Source:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

The dataset contains information about e-commerce transactions, including customer details, orders, products, sellers, payments, and customer reviews.

The analysis uses multiple relational tables connected through common identifiers.

## Data Cleaning & Preparation

- Imported raw e-commerce data into MySQL staging tables.
- Examined missing values, duplicate records, and data consistency.
- Converted text-based fields into appropriate numerical and date formats.
- Used SQL functions such as `TRIM()`, `NULLIF()`, `CAST()`, and `STR_TO_DATE()`.
- Created structured tables to support relational data analysis.
- Performed record-count checks to validate data preparation.

## SQL Analysis Performed

### 1. Revenue & Product Category Analysis
- Analyzed revenue and order volume across product categories.
- Identified top-performing categories and products.
- Examined monthly revenue trends and month-over-month growth.
- Analyzed customer review scores for selected products.

### 2. Customer Segmentation
- Explored customer purchasing patterns using Recency, Frequency, and Monetary (RFM) metrics.
- Applied SQL window functions to calculate customer scores.

### 3. Seller Performance Analysis
- Evaluated sellers based on revenue, fulfilled orders, delivery duration, and customer ratings.
- Ranked sellers by revenue within their states.
- Identified potential underperformers based on delivery times and review scores.

### 4. Geographical & Shipping Analysis
- Analyzed revenue and customer distribution across Brazilian states.
- Examined average delivery times and late deliveries.
- Compared shipping performance within and across states.

### 5. Payment Behavior Analysis
- Explored popular payment methods and transaction patterns.
- Analyzed payment installments across different order values.
- Examined customer review scores across installment groups.

### 6. Customer Retention Analysis
- Used monthly cohort analysis to examine repeat purchasing behavior.
- Calculated customer retention percentages across different months.

## Skills Demonstrated

- SQL Data Cleaning & Transformation
- Relational Database Management
- SQL Joins & Aggregations
- Common Table Expressions (CTEs)
- Window Functions
- Data Validation
- Business Data Analysis
- Analytical Problem-Solving

## Project Files

- `olist_ecommerce_project.sql` — SQL script containing data preparation and analytical queries.

**Note:** Raw dataset files are not included in this repository. The original dataset can be accessed through the Kaggle link provided above.

## Project Status

SQL analysis script uploaded. Project documentation and findings may be updated as further results are reviewed.
