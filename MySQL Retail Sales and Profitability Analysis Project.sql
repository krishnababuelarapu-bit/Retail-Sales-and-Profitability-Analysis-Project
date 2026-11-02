CREATE DATABASE Retail_Db;
USE retail_db;



CREATE TABLE staging_sales (
    ORDERNUMBER INT, QUANTITYORDERED INT, 
    PRICEEACH DECIMAL(10,2),
    ORDERLINENUMBER INT, 
    SALES DECIMAL(10,2),
    ORDERDATE VARCHAR(30),
    STATUS VARCHAR(20), 
    QTR_ID INT, 
    MONTH_ID INT, 
    YEAR_ID INT,
    PRODUCTLINE VARCHAR(30), 
    MSRP INT, 
    PRODUCTCODE VARCHAR(20),
    CUSTOMERNAME VARCHAR(60), 
    PHONE VARCHAR(30),
    ADDRESSLINE1 VARCHAR(80), 
    ADDRESSLINE2 VARCHAR(30),
    CITY VARCHAR(30), 
    STATE VARCHAR(30), 
    POSTALCODE VARCHAR(20),
    COUNTRY VARCHAR(30), 
    TERRITORY VARCHAR(20),
    CONTACTLASTNAME VARCHAR(30), 
    CONTACTFIRSTNAME VARCHAR(30),
    DEALSIZE VARCHAR(10)
);
SELECT * FROM staging_sales;
SELECT COUNT(*) FROM staging_sales;
SELECT DISTINCT TERRITORY FROM staging_sales;


-- Splitting the staging_sales Table into different 4 sub tables to finding the query insights easier 
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(60) UNIQUE NOT NULL,
    phone VARCHAR(30),
    address_line1 VARCHAR(80),
    address_line2 VARCHAR(30),
    city VARCHAR(30),
    state VARCHAR(30),
    postal_code VARCHAR(20),
    country VARCHAR(30),
    territory VARCHAR(20),
    contact_last_name VARCHAR(30),
    contact_first_name VARCHAR(30)
);

SELECT * FROM Customers;

CREATE TABLE products (
    product_code VARCHAR(20) PRIMARY KEY,
    product_line VARCHAR(30),
    msrp INT
);

SELECT * FROM Products;

CREATE TABLE orders (
    order_number INT PRIMARY KEY,
    order_date DATETIME,
    status VARCHAR(20),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

SELECT * FROM orders;

CREATE TABLE order_details (
    order_number INT,
    order_line_number INT,
    product_code VARCHAR(20),
    quantity_ordered INT,
    price_each DECIMAL(10,2),
    sales DECIMAL(10,2),
    deal_size VARCHAR(10),
    PRIMARY KEY (order_number, order_line_number),
    FOREIGN KEY (order_number) REFERENCES orders(order_number),
    FOREIGN KEY (product_code) REFERENCES products(product_code)
);

SELECT * FROM order_details;

-- Inserting the data into respected tables
-- 1.Customers Table Data
INSERT INTO customers (customer_name, phone, address_line1, address_line2,
                       city, state, postal_code, country, territory,
                       contact_last_name, contact_first_name)
SELECT DISTINCT CUSTOMERNAME, PHONE, ADDRESSLINE1, NULLIF(ADDRESSLINE2,''),
       CITY, NULLIF(STATE,''), NULLIF(POSTALCODE,''), COUNTRY, TERRITORY,
       CONTACTLASTNAME, CONTACTFIRSTNAME
FROM staging_sales;

-- 2.Products Table Data
INSERT INTO products (product_code, product_line, msrp)
SELECT DISTINCT PRODUCTCODE, PRODUCTLINE, MSRP
FROM staging_sales;

-- 3.Orders Table Data
INSERT INTO orders (order_number, order_date, status, customer_id)
SELECT DISTINCT s.ORDERNUMBER,
       STR_TO_DATE(s.ORDERDATE, '%m/%d/%Y %H:%i'),
       s.STATUS, c.customer_id
FROM staging_sales s
JOIN customers c ON c.customer_name = s.CUSTOMERNAME;

-- 4.Order_details Data
INSERT INTO order_details (order_number, order_line_number, product_code,
                           quantity_ordered, price_each, sales, deal_size)
SELECT ORDERNUMBER, ORDERLINENUMBER, PRODUCTCODE,
       QUANTITYORDERED, PRICEEACH, SALES, DEALSIZE
FROM staging_sales;

SELECT * FROM customers; 
SELECT * FROM products; 
SELECT * FROM orders;   
SELECT * FROM order_details;

-- Checking dupliacates and Missing values

SELECT ORDERNUMBER, ORDERLINENUMBER, PRODUCTCODE, QUANTITYORDERED, SALES, COUNT(*) AS times
FROM staging_sales
GROUP BY ORDERNUMBER, ORDERLINENUMBER, PRODUCTCODE, QUANTITYORDERED, SALES
HAVING COUNT(*) > 1;

-- customers: same name more than once
SELECT customer_name, COUNT(*) AS times
FROM customers
GROUP BY customer_name
HAVING COUNT(*) > 1;

-- products: same product code more than once
SELECT product_code, COUNT(*) AS times
FROM products
GROUP BY product_code
HAVING COUNT(*) > 1;

-- orders: same order number more than once
SELECT order_number, COUNT(*) AS times
FROM orders
GROUP BY order_number
HAVING COUNT(*) > 1;

-- order_details: same order line more than once
SELECT order_number, order_line_number, COUNT(*) AS times
FROM order_details
GROUP BY order_number, order_line_number
HAVING COUNT(*) > 1;

-- 1    What are total revenue, orders, and customers? # using Aggregate functions
SELECT ROUND(SUM(d.sales), 2)         AS total_revenue,
       COUNT(DISTINCT o.order_number) AS total_orders,
       COUNT(DISTINCT o.customer_id)  AS total_customers
FROM orders o
JOIN order_details d 
ON d.order_number = o.order_number
WHERE o.status <> 'Cancelled';

-- 2    Which product line generates the highest revenue? # using subquery
SELECT p.product_line, ROUND(SUM(d.sales), 2) AS revenue
FROM order_details d
JOIN orders o   
ON o.order_number = d.order_number
JOIN products p 
ON p.product_code = d.product_code
WHERE o.status <> 'Cancelled'
GROUP BY p.product_line
HAVING SUM(d.sales) = (SELECT MAX(line_revenue)
                       FROM (SELECT SUM(d2.sales) AS line_revenue
                             FROM order_details d2
                             JOIN orders o2   
                             ON o2.order_number = d2.order_number
							 JOIN products p2 
                             ON p2.product_code = d2.product_code
                             WHERE o2.status <> 'Cancelled'
                             GROUP BY p2.product_line) AS x);
-- 3    Who are the top 10 customers by revenue? # using CTE
WITH customer_revenue AS (      
    SELECT c.customer_id, c.customer_name, c.country, SUM(d.sales) AS revenue
    FROM customers c
    JOIN orders o        
    ON o.customer_id  = c.customer_id
    JOIN order_details d 
    ON d.order_number = o.order_number
    WHERE o.status <> 'Cancelled'
    GROUP BY c.customer_id, c.customer_name, c.country
)
SELECT customer_name, country, ROUND(revenue, 2) AS revenue  
FROM customer_revenue
ORDER BY revenue DESC                            
LIMIT 10;                                        

-- 4    Which month generates the highest sales? # using date functions
SELECT MONTH(o.order_date)     AS month_no,      
       MONTHNAME(o.order_date) AS month_name,    
       ROUND(SUM(d.sales), 2)  AS revenue
FROM orders o
JOIN order_details d 
ON d.order_number = o.order_number
WHERE o.status <> 'Cancelled'
GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)  
ORDER BY revenue DESC;

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS year_month_,   
       ROUND(SUM(d.sales), 2)             AS revenue
FROM orders o
JOIN order_details d ON d.order_number = o.order_number
WHERE o.status <> 'Cancelled'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY revenue DESC
LIMIT 1;

-- 5    What is the year-over-year revenue growth? # using window functions
SELECT YEAR(o.order_date)       AS order_year,
       MAX(MONTH(o.order_date)) AS last_month,    
       ROUND(SUM(d.sales), 2)   AS revenue,
       ROUND(LAG(SUM(d.sales)) OVER (ORDER BY YEAR(o.order_date)), 2) AS prev_year_revenue,
       ROUND(100 * (SUM(d.sales) - LAG(SUM(d.sales)) OVER (ORDER BY YEAR(o.order_date)))
                 /  LAG(SUM(d.sales)) OVER (ORDER BY YEAR(o.order_date)), 1) AS yoy_growth_pct
FROM orders o
JOIN order_details d ON d.order_number = o.order_number
WHERE o.status <> 'Cancelled'
GROUP BY YEAR(o.order_date)                       
ORDER BY order_year;

-- 6    Which countries contribute more than 5% of revenue? # using DT
SELECT ct.country,
       ROUND(ct.revenue, 2)                           AS revenue,
       ROUND(100 * ct.revenue / tot.total_revenue, 2) AS pct_of_revenue
FROM (SELECT c.country, SUM(d.sales) AS revenue      
      FROM customers c
      JOIN orders o        ON o.customer_id  = c.customer_id
      JOIN order_details d ON d.order_number = o.order_number
      WHERE o.status <> 'Cancelled'
      GROUP BY c.country) AS ct
CROSS JOIN (SELECT SUM(d.sales) AS total_revenue      
            FROM order_details d
            JOIN orders o ON o.order_number = d.order_number
            WHERE o.status <> 'Cancelled') AS tot
WHERE 100 * ct.revenue / tot.total_revenue > 5
ORDER BY ct.revenue DESC;
-- 7    Which products have an average selling price above the overall average? # scalar subquery
SELECT p.product_code, p.product_line,
       ROUND(SUM(d.sales) / SUM(d.quantity_ordered), 2) AS avg_selling_price   
FROM order_details d
JOIN orders o   ON o.order_number = d.order_number
JOIN products p ON p.product_code = d.product_code
WHERE o.status <> 'Cancelled'
GROUP BY p.product_code, p.product_line
HAVING SUM(d.sales) / SUM(d.quantity_ordered) >        
       (SELECT SUM(d2.sales) / SUM(d2.quantity_ordered)
        FROM order_details d2
        JOIN orders o2 ON o2.order_number = d2.order_number
        WHERE o2.status <> 'Cancelled')
ORDER BY avg_selling_price DESC;
-- 8    Which customers place more orders than the average customer? # using correlated subquery
SELECT c.customer_name, c.country,
       (SELECT COUNT(*)                                
        FROM orders o2
        WHERE o2.customer_id = c.customer_id           
          AND o2.status <> 'Cancelled') AS order_count
FROM customers c
WHERE (SELECT COUNT(*)
       FROM orders o3
       WHERE o3.customer_id = c.customer_id
         AND o3.status <> 'Cancelled')
      > (SELECT COUNT(*) / COUNT(DISTINCT o4.customer_id)   
         FROM orders o4
         WHERE o4.status <> 'Cancelled')
ORDER BY order_count DESC, c.customer_name;

-- 9    Which product lines rank highest in sales quantity? # using Dense Rank() 
SELECT p.product_line,
       SUM(d.quantity_ordered) AS units_sold,
       DENSE_RANK() OVER (ORDER BY SUM(d.quantity_ordered) DESC) AS quantity_rank  
FROM order_details d
JOIN orders o   ON o.order_number = d.order_number
JOIN products p ON p.product_code = d.product_code
WHERE o.status <> 'Cancelled'
GROUP BY p.product_line                            
ORDER BY quantity_rank;                            
 
-- 10    Which products have the largest gap between MSRP and selling price? # Case Expression
SELECT p.product_code, p.product_line, p.msrp,
       ROUND(SUM(d.sales) / SUM(d.quantity_ordered), 2)          AS avg_selling_price,
       ROUND(p.msrp - SUM(d.sales) / SUM(d.quantity_ordered), 2) AS msrp_gap,   
       CASE WHEN SUM(d.sales) / SUM(d.quantity_ordered) < p.msrp THEN 'Sold below MSRP'
            WHEN SUM(d.sales) / SUM(d.quantity_ordered) > p.msrp THEN 'Sold above MSRP'
            ELSE 'Sold at MSRP' END                               AS price_position
FROM order_details d
JOIN orders o   ON o.order_number = d.order_number
JOIN products p ON p.product_code = d.product_code
WHERE o.status <> 'Cancelled'
GROUP BY p.product_code, p.product_line, p.msrp      
ORDER BY ABS(p.msrp - SUM(d.sales) / SUM(d.quantity_ordered)) DESC  
LIMIT 10;