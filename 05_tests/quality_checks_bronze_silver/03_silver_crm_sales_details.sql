/*
============================================
Table: silver.crm_sales_details
============================================
*/

-- Table: silver.crm_sales_details

SELECT * FROM silver.crm_sales_details;

-- 1) Strings

	-- Are there whitespaces?

	SELECT
		*
	FROM silver.crm_sales_details
	WHERE 
		-- LENGTH(sls_ord_num) != LENGTH(TRIM(sls_ord_num))		-- None
		-- LENGTH(sls_prd_key) != LENGTH(TRIM(sls_prd_key))		-- None


	-- Is the casing the same?
	SELECT
		*
	FROM silver.crm_sales_details
	-- WHERE sls_ord_num != UPPER(sls_ord_num)		-- Same
	WHERE sls_prd_key != UPPER(sls_prd_key)		-- Same


	-- Are there weird characters with no sense?
	SELECT
		*
	FROM silver.crm_sales_details
	-- WHERE sls_ord_num ~ '[^a-zA-Z0-9 -]'		-- None
	WHERE sls_prd_key ~ '[^a-zA-Z0-9 -]'	-- None


/*
---------------------------------------
---------------------------------------
---------------------------------------
*/

	-- 2) Numeric Values
	
	-- Check if the join will work with crm_cust_info
	SELECT
		sls_cust_id
	FROM silver.crm_sales_details 
	WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);	-- All customers have placed an order
	

	-- Sales = Quantity * Price

	-- zeros, negatives and nulls are not allowed
	-- the formula must be working

	SELECT
		sls_sales,
		sls_quantity,
		sls_price
	FROM silver.crm_sales_details 
	WHERE
		sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_price * sls_quantity OR
		sls_price <= 0 OR sls_price IS NULL OR
		sls_quantity <= 0 OR sls_quantity IS NULL 	
	ORDER BY 1, 2, 3



/*
---------------------------------------
---------------------------------------
---------------------------------------
*/


	-- 3) Dates

	-- Check for extreme dates (eg. > 2050-01-01 	< 1900-01-01)
	SELECT
		sls_ord_num,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt
	FROM silver.crm_sales_details
	WHERE sls_order_dt > '2050-01-01' OR sls_order_dt < '1900-01-01' OR
		sls_ship_dt > '2050-01-01' OR sls_ship_dt < '1900-01-01' OR
	 	sls_due_dt > '2050-01-01' OR sls_due_dt < '1900-01-01';

	-- Also order date must be 'LESS THAN' ship date and due_date
	SELECT
		sls_ord_num,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt
	FROM silver.crm_sales_details
	WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt
		OR sls_ship_dt > sls_due_dt 		
	-- Result: None
		
