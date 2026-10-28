/*
===============================================================================
IV. MEASURES EXPLORATION
===============================================================================
Purpose:
    Calculate key business metrics to establish a high-level overview of the
    business.
===============================================================================
*/

SELECT
    'Total Customers' AS measure_name,
    COUNT(customer_key) AS value
FROM gold.dim_customers

UNION ALL

SELECT
    'Active Customers',
    COUNT(DISTINCT customer_key)
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Products',
    COUNT(product_key)
FROM gold.dim_products

UNION ALL

SELECT
    'Active Products',
    COUNT(DISTINCT product_key)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Cost',
    ROUND(AVG(cost), 2)
FROM gold.dim_products

UNION ALL

SELECT
    'Total Orders',
    COUNT(DISTINCT order_number)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Line Price',
    ROUND(AVG(price), 2)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Line Quantity',
    ROUND(AVG(quantity), 2)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Line Sales',
    ROUND(AVG(sales_amount), 2)
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Sales',
    SUM(sales_amount)
FROM gold.fact_sales;

-- Result:
-- measure_name          | value
-- ----------------------+----------
-- Total Customers       | 18484
-- Active Customers      | 18484
-- Total Products        | 295
-- Active Products       | 130
-- Average Cost          | 431.07
-- Total Orders          | 27659
-- Average Line Price    | 486.04
-- Average Line Quantity | 1.00
-- Average Line Sales    | 486.05
-- Total Sales           | 29356250