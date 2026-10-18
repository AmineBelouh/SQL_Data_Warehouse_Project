/*
============================================
Table: bronze.crm_sales_details
============================================
*/

-- 1) Strings

	-- Are there whitespaces?

	SELECT
		*
	FROM bronze.crm_sales_details
	WHERE 
		-- LENGTH(sls_ord_num) != LENGTH(TRIM(sls_ord_num))		-- None
		-- LENGTH(sls_prd_key) != LENGTH(TRIM(sls_prd_key))		-- None


	-- Is the casing the same?
	SELECT
		*
	FROM bronze.crm_sales_details
	-- WHERE sls_ord_num != UPPER(sls_ord_num)		-- Same
	WHERE sls_prd_key != UPPER(sls_prd_key)		-- Same


	-- Are there weird characters with no sense?
	SELECT
		*
	FROM bronze.crm_sales_details
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
	FROM bronze.crm_sales_details 
	WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);	-- All customers have placed an order
	

	-- Sales = Quantity * Price

	-- zeros, negatives and nulls are not allowed
	-- the formula must be working

	SELECT
		sls_sales,
		sls_quantity,
		sls_price,
		CASE 
			WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != ABS(sls_price) * sls_quantity 
					THEN  ABS(sls_price) * sls_quantity 
			ELSE sls_sales
		END AS sls_sales,
		sls_quantity,
		CASE 
			WHEN sls_price <= 0 OR sls_price IS NULL 
					THEN sls_sales / NULLIF(sls_quantity, 0)
			ELSE sls_price
		END AS sls_price
	FROM bronze.crm_sales_details 
	WHERE
		sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_price * sls_quantity OR
		sls_price <= 0 OR sls_price IS NULL OR
		sls_quantity <= 0 OR sls_quantity IS NULL 	-- No problem with quantity
	ORDER BY 1, 2, 3



/*
---------------------------------------
---------------------------------------
---------------------------------------
*/


	-- 3) Dates

	-- Check for extreme dates (eg. > 20500101 	< 19000101)
	SELECT
		sls_ord_num,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt
	FROM bronze.crm_sales_details
	WHERE sls_order_dt > 20500101 OR sls_order_dt < 19000101 OR
		sls_ship_dt > 20500101 OR sls_ship_dt < 19000101 OR
	 	sls_due_dt > 20500101 OR sls_due_dt < 19000101;


	-- Issues Found: 0 and numbers of length < 8 cannot be converted to date
	SELECT
		sls_ord_num,
		CASE
			WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::VARCHAR) < 8 THEN NULL
			ELSE sls_order_dt::VARCHAR(50)::DATE
		END sls_order_dt,
		CASE
			WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::VARCHAR) < 8 THEN NULL
			ELSE sls_ship_dt::VARCHAR(50)::DATE
		END sls_ship_dt,
		CASE
			WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::VARCHAR) < 8 THEN NULL
			ELSE sls_due_dt::VARCHAR(50)::DATE
		END sls_due_dt
	FROM bronze.crm_sales_details
	WHERE sls_order_dt > 20500101 OR sls_order_dt < 19000101 OR
		sls_ship_dt > 20500101 OR sls_ship_dt < 19000101 OR
	 	sls_due_dt > 20500101 OR sls_due_dt < 19000101;


	-- Also order date must be 'LESS THAN' ship date and due_date
	SELECT
		sls_ord_num,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt
	FROM bronze.crm_sales_details
	WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt
		OR sls_ship_dt > sls_due_dt 		
	-- Result: None
		


