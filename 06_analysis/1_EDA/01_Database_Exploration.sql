/*
===============================================================================
I. DATABASE EXPLORATION
===============================================================================
Purpose:
    Inspect the tables/views and columns available in the Gold schema.
===============================================================================
*/

SELECT
    table_catalog,
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'gold';

-- Result:
-- table_catalog | table_schema | table_name     | table_type
-- --------------+--------------+----------------+-----------
-- datawarehouse | gold         | dim_products   | VIEW
-- datawarehouse | gold         | dim_customers  | VIEW
-- datawarehouse | gold         | fact_sales     | VIEW


SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'gold'
ORDER BY table_name;

/* Result:
table_name       | column_name      | data_type
-----------------|------------------|-----------------------
dim_customers    | customer_number  | character varying
dim_customers    | marital_status   | character varying
dim_customers    | country          | character varying
dim_customers    | gender           | character varying
dim_customers    | customer_key     | bigint
dim_customers    | customer_id      | integer
dim_customers    | birthdate        | date
dim_customers    | create_date      | date
dim_customers    | last_name        | character varying
dim_customers    | first_name       | character varying

dim_products     | product_key      | bigint
dim_products     | product_id       | integer
dim_products     | start_date       | date
dim_products     | cost             | integer
dim_products     | product_number   | character varying
dim_products     | product_name     | character varying
dim_products     | product_line     | character varying
dim_products     | category_id      | character varying
dim_products     | category         | character varying
dim_products     | subcategory      | character varying
dim_products     | maintenance      | character varying

fact_sales       | product_key      | bigint
fact_sales       | customer_key     | bigint
fact_sales       | quantity         | integer
fact_sales       | sales_amount     | integer
fact_sales       | price            | integer
fact_sales       | order_number     | character varying
fact_sales       | due_date         | date
fact_sales       | shipping_date    | date
fact_sales       | order_date       | date
*/