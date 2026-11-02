# Retail-Sales-and-Profitability-Analysis-Project
Analyze retail sales data using MySQL to identify revenue trends, top-performing products, valuable customers, and sales patterns. This project covers database design, data cleaning, normalization, joins, subqueries, CTEs, aggregate functions, and window functions to generate meaningful business insights.
# 🛒 MySQL Retail Sales and Profitability Analysis | SQL Project

## 📌 Project Overview

This project focuses on analyzing retail sales data using **MySQL** to identify revenue trends, evaluate product performance, understand customer purchasing behavior, and generate meaningful business insights.

The project involves database creation, data cleaning, data transformation, normalization, and advanced SQL queries to analyze historical retail transactions and support data-driven business decisions.

---

## 🎯 Objectives

- Analyze overall retail sales and revenue performance.
- Identify top-performing product lines.
- Find the top 10 customers based on revenue.
- Analyze monthly and yearly sales trends.
- Calculate year-over-year revenue growth.
- Evaluate country-wise revenue contributions.
- Identify products with above-average selling prices.
- Analyze customer order frequency.
- Rank product lines based on sales quantity.
- Compare product MSRP with actual average selling prices.

---

## 📊 Database Tables

The project uses a relational database consisting of five tables:

### 🗄️ 1. Staging Sales
- Stores the original raw retail sales dataset.
- Acts as the source table for data transformation.

### 👥 2. Customers
- Customer ID
- Customer Name
- Phone
- Address
- City
- State
- Country
- Territory

### 📦 3. Products
- Product Code
- Product Line
- MSRP

### 🧾 4. Orders
- Order Number
- Order Date
- Order Status
- Customer ID

### 📋 5. Order Details
- Order Number
- Order Line Number
- Product Code
- Quantity Ordered
- Price Each
- Sales
- Deal Size

---

## 📌 Key Performance Indicators (KPIs)

- 💰 Total Revenue
- 🧾 Total Orders
- 👥 Total Customers
- 📦 Total Quantity Sold
- 🏆 Highest Revenue Product Line
- 🌍 Country-wise Revenue Contribution
- 📈 Year-over-Year Revenue Growth

---

## 📈 SQL Analysis Performed

- Total Revenue, Orders, and Customers Analysis
- Product Line Revenue Analysis
- Top 10 Customers by Revenue
- Monthly and Yearly Sales Trend Analysis
- Year-over-Year Revenue Growth using `LAG()`
- Country-wise Revenue Contribution
- Average Selling Price Analysis
- Customer Order Frequency Analysis
- Product Line Ranking using `DENSE_RANK()`
- MSRP vs Average Selling Price Analysis using `CASE`

---

## 🛠️ Tools & Technologies

- MySQL
- MySQL Workbench
- SQL
- Relational Database Management
- Data Cleaning and Transformation
- Database Normalization
- Primary Keys and Foreign Keys
- Joins and Aggregate Functions
- Subqueries and CTEs
- Window Functions
- Date and String Functions
- CASE Statements

---

## 📂 Dataset Features

The project uses a historical retail sales dataset containing 2,823 records and 25 columns.

Key dataset attributes:

- Order Number
- Quantity Ordered
- Price Each
- Sales
- Order Date
- Order Status
- Product Line
- MSRP
- Product Code
- Customer Name
- City
- State
- Country
- Territory
- Deal Size

---

## 📈 Business Insights

- Classic Cars generated the highest revenue among all product lines.
- November 2004 recorded the highest monthly revenue.
- The USA contributed the largest share of total revenue.
- Customer revenue analysis identified the highest-value customers.
- Year-over-year analysis showed revenue growth in 2004 compared with 2003.
- Product pricing analysis identified differences between MSRP and average selling prices.
- Product line ranking helped identify the highest-selling categories by quantity.

---

## 🚀 Project Features

- ✔ Raw CSV Data Import
- ✔ Database Creation and Management
- ✔ Data Cleaning and Duplicate Checking
- ✔ Relational Database Design
- ✔ Data Normalization
- ✔ Primary Key and Foreign Key Relationships
- ✔ Complex SQL Queries
- ✔ CTEs and Subqueries
- ✔ Window Function Analysis
- ✔ Business Insights Generation

---

## 📷 Project Preview

### Database ER Diagram

> Add ER Diagram Screenshot Here

### SQL Query Results

> Add MySQL Workbench Query Output Screenshots Here

---

## 📁 Project Structure

```text
MySQL-Retail-Sales-Analysis/
│
├── MySQL Retail Sales and Profitability Analysis Project.sql
├── sales_data_sample.csv
├── ER Diagram of Unique Project.mwb
├── README.md
│
└── Screenshots/
    ├── Database-Design.png
    ├── Data-Cleaning.png
    ├── Revenue-Analysis.png
    └── SQL-Query-Results.png
```

---

## 🎯 Skills Demonstrated

- SQL Query Writing
- Data Cleaning and Transformation
- Database Design
- Relational Database Management
- Data Analysis
- Business Intelligence
- Revenue Trend Analysis
- Customer Segmentation
- Analytical Thinking
- Problem-Solving

---

## 👨‍💻 Author

**Krishna Babu Elarapu**

- LinkedIn: [linkedin.com/in/krishna-babu-elarapu-619457355](https://www.linkedin.com/in/krishna-babu-elarapu-619457355/)
- GitHub: [github.com/krishnababuelarapu-bit](https://github.com/krishnababuelarapu-bit)

---

*Note: The dataset contains sales revenue and pricing information but does not include actual product costs. Therefore, the project focuses on revenue and sales performance analysis rather than verified profit or profit-margin calculations.*
