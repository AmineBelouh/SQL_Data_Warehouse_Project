/*
=======================================
-- Table: silver.erp_loc_a101
=======================================
*/

-- Check if there are duplicates
SELECT
	cid,
	COUNT(*)
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1		-- No Results

-- Check for white spaces
SELECT * FROM silver.erp_loc_a101 WHERE LENGTH(cid) != LENGTH(TRIM(cid))	-- None

-- Check if the join works
SELECT 
	cid
FROM silver.erp_loc_a101
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)	-- Good


-- Low Cardinality column
SELECT DISTINCT
	cntry
FROM silver.erp_loc_a101
