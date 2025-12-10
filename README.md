# 📌 Store Sales SQL Project

A complete end-to-end SQL project using MySQL to clean, standardize and analyze retail store sales data.  
The project includes **data cleaning, error correction, transformations, and business insights** using real SQL queries.

---

## 🧾 Project Overview
This project focuses on analyzing store sales data that contains customer details, product information, purchase timings, payment modes, and order status.

The goal was to:
- Clean raw data  
- Fix duplicates and incorrect values  
- Standardize inconsistent entries  
- Identify key business trends  
- Generate insights that support better decision-making  

---

## 🗂️ Dataset Information
The dataset contains the following columns:

- `transaction_id`
- `customer_id`, `customer_name`, `customer_age`, `gender`
- `product_id`, `product_name`, `product_category`
- `quantity`, `price`
- `payment_mode`
- `purchase_date`, `time_of_purchase`
- `status` (delivered / cancelled / returned)

---

## 🧹 Data Cleaning Performed

### ✔ 1. Removed Duplicate Records
Used `ROW_NUMBER()` with CTE to find and delete duplicate transaction IDs.

### ✔ 2. Renamed Incorrect Columns
- `quantiy` → `Quantity`
- `prce` → `Price`

### ✔ 3. Identified Missing & NULL Values
Checked null count for each column and listed all rows containing NULLs.

### ✔ 4. Corrected Wrong Customer Records
Updated incorrect customer IDs and names.

### ✔ 5. Standardized Category Values
- Gender values: `Male → M`, `Female → F`
- Payment Mode: `CC → Credit Card`

---

## 📊 Business Analysis Performed

### 🔹 1. Top 5 Selling Products  
Identified products with the highest quantity sold.

### 🔹 2. Most Cancelled Products  
Analysed products most frequently cancelled by customers.

### 🔹 3. Peak Purchase Hour  
Grouped orders by hour to find when customers purchase the most.

### 🔹 4. Top Spending Customers  
Calculated total spend by each customer.

### 🔹 5. Revenue by Product Category  
Found product categories contributing the highest revenue.

### 🔹 6. Cancellation / Return Rate by Category  
Calculated % of cancelled and returned items.

### 🔹 7. Most Preferred Payment Mode  
Found the most used payment option.

### 🔹 8. Customer Age Group Analysis  
Grouped customers into age segments to compare purchasing behavior.

### 🔹 9. Monthly Sales Trend  
Identified seasonal / monthly sales patterns.

---

## ⭐ Key Business Insights
- Identified top-selling and underperforming products.
- Found that certain categories have high cancellation/return rates.
- Peak purchase hours supported staffing and marketing decisions.
- High-value customers can be targeted for loyalty programs.
- Monthly trends showed seasonal buying behavior.


---

## 🛠️ Tech Stack
- MySQL  
- SQL Window Functions  
- Aggregations  
- CTEs  
- Date & Time Functions  
- Data Cleaning Queries  

---

## 📁 Project Files
- `STORE_SALES_SQL_PROJECT.sql` → Full SQL code (cleaning + analysis)

---

## 📝 Author
**Abhishek Bity**  
Ms Excel | SQL | Power BI | Tableau | Python | Data Analysis  

---


