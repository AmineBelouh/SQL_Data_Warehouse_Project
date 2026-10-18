/*
=======================================
-- Table: bronze.erp_loc_a101
=======================================
*/

-- Check if there are duplicate
SELECT
	cid,
	COUNT(*)
FROM bronze.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1		-- No Results

-- Check for white spaces
SELECT * FROM bronze.erp_loc_a101 WHERE LENGTH(cid) != LENGTH(TRIM(cid))	-- None

-- Check if the join works
SELECT 
	REPLACE(cid, '-', '')
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info)	-- Good


-- Low Cardinality column
SELECT DISTINCT
	cntry,
	CASE
		WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
		WHEN UPPER(TRIM(cntry)) IN ('FR', 'FRANCE') THEN 'France'
		WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
		WHEN UPPER(TRIM(cntry)) IN ('UK', 'UNITED KINGDOM') THEN 'United Kingdom'
		WHEN UPPER(TRIM(cntry)) IN ('AUSTRALIA') THEN 'Australia'
		WHEN UPPER(TRIM(cntry)) IN ('CANADA') THEN 'Canada'
		ELSE 'n/a'
	END AS cntry
FROM bronze.erp_loc_a101
