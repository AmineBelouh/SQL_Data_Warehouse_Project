/*
========================================
-- Table: silver.erp_cust_az12
========================================
*/

	SELECT * FROM silver.erp_cust_az12;

	-- 1)	Remove Duplicates
	SELECT 
		cid,
		COUNT(*) 
	FROM silver.erp_cust_az12
	GROUP BY cid
	HAVING COUNT(*) > 1;	-- No Duplicates

	
	-- 'cid' is used to join with crm_cust_info 
	
	SELECT 
		cid
	FROM silver.erp_cust_az12
	WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)		-- Good


	-- Checking for white spaces in id
	SELECT 
		cid
	FROM silver.erp_cust_az12
	WHERE LENGTH(cid) != LENGTH(TRIM(cid))	-- None


	-- 2) Low Cardinality Column
	SELECT
		DISTINCT gen
	FROM silver.erp_cust_az12


	-- 3) Date 		
	
	SELECT
		MIN(bdate),
		MAX(bdate)
	FROM silver.erp_cust_az12

	-- Age must be at least 18 years old
	SELECT
		*
	FROM silver.erp_cust_az12
	WHERE bdate > (CURRENT_DATE - INTERVAL '18 years')::DATE









