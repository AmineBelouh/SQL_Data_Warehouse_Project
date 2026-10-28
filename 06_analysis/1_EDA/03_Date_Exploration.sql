/*
===============================================================================
III. DATE EXPLORATION
===============================================================================
Purpose:
    Identify date boundaries and understand the timespan of sales data and the
    birth-date range of customers.
===============================================================================
*/

-- 1. Sales date boundaries and duration
SELECT
    MIN(order_date) AS first_date_sale,
    MAX(order_date) AS latest_date_sale,
    EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) || ' years' AS years_of_sales,
    (
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12
        + EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) ) || ' months' AS months_of_sales
FROM gold.fact_sales;

-- Result:
-- first_date_sale | latest_date_sale | years_of_sales | months_of_sales
-- ----------------+------------------+----------------+----------------
-- 2010-12-29      | 2014-01-28       | 3 years        | 36 months


-- 2. Oldest and youngest customers by birth date
SELECT
    MIN(birthdate) AS oldest_customer,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(birthdate))) || ' years old' AS oldest_customer_age,
    MAX(birthdate) AS youngest_customer,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, MAX(birthdate))) || ' years old' AS youngest_customer_age
FROM gold.dim_customers;

-- Result:
-- oldest_customer | oldest_customer_age | youngest_customer | youngest_customer_age
-- ----------------+---------------------+-------------------+----------------------
-- 1916-02-10      | 110 years old       | 1986-06-25        | 40 years old