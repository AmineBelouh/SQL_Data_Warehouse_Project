/*
============================================
Table: bronze.erp_cust_az12
============================================
*/

	-- 1)	Remove Duplicates
	SELECT 
		cid,
		COUNT(*) 
	FROM bronze.erp_cust_az12
	GROUP BY cid
	HAVING COUNT(*) > 1;	-- No Duplicates

	
	-- 'cid' is used to join with crm_cust_info 
	
	SELECT 
		CASE
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
			ELSE cid
		END AS cid
	FROM bronze.erp_cust_az12
	WHERE 
		CASE
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
			ELSE cid
		END NOT IN (SELECT cst_key FROM silver.crm_cust_info)	-- Good


	-- Checking for white spaces in id
	SELECT 
		cid
	FROM bronze.erp_cust_az12
	WHERE LENGTH(cid) != LENGTH(TRIM(cid))	-- None


	-- 2) Low Cardinality Column
	SELECT
		DISTINCT gen,
		CASE
			WHEN UPPER(TRIM(gen)) IN ('MALE', 'M') THEN 'Male' 
			WHEN UPPER(TRIM(gen)) IN ('FEMALE', 'F') THEN 'Female'
			ELSE 'n/a'
		END AS gen
	FROM bronze.erp_cust_az12


	-- 3) Date 		
	
	-- 	"1916-02-10"	"9999-11-20"
	SELECT
		MIN(bdate),
		MAX(bdate)
	FROM bronze.erp_cust_az12

	-- Age must be at least 18 years old
	SELECT
		*,
		CASE
			WHEN bdate > (CURRENT_DATE - INTERVAL '18 years')::DATE THEN NULL
			ELSE bdate
		END AS bdate
	FROM bronze.erp_cust_az12
	WHERE bdate > (CURRENT_DATE - INTERVAL '18 years')::DATE


SELECT 
	CURRENT_DATE,
	(CURRENT_DATE - INTERVAL '18 years')::DATE

