/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer.
===============================================================================
*/


-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results

SELECT 
	customer_key,
	COUNT(*) 
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


/* Data Integration (we have 2 sources for the gender info)	
		 The master source of customer data is CRM */
SELECT DISTINCT gender FROM gold.dim_customers; 

-- How it was done
SELECT DISTINCT
	ci.cst_gndr, 
	ca.gen,
	CASE
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE ca.gen
	END gender
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid;


-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results

SELECT 
	product_key,
	COUNT(*) 
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================

-- Check if the joins are working
SELECT
	*
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;
