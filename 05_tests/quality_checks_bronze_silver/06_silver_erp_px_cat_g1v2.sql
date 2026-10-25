/*
=======================================
Table: silver.erp_px_cat_g1v2
=======================================
*/

-- ID: Check if there are duplicates
SELECT 
	id,
	COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1;	-- No Results

-- Check if there are white spaces
SELECT 
	id, cat, subcat, maintenance
FROM silver.erp_px_cat_g1v2
WHERE 
	LENGTH(id) != LENGTH(TRIM(id)) OR
	LENGTH(cat) != LENGTH(TRIM(cat)) OR
	LENGTH(subcat) != LENGTH(TRIM(subcat)) OR
	LENGTH(maintenance) != LENGTH(TRIM(maintenance));		-- No Results

-- Check if the join works
SELECT
	*
FROM silver.erp_px_cat_g1v2
WHERE id NOT IN (SELECT DISTINCT prd_cat FROM silver.crm_prd_info); 

	
-- Low Cardinality Columns
SELECT
	DISTINCT cat
FROM silver.erp_px_cat_g1v2		-- good

SELECT
	DISTINCT subcat
FROM silver.erp_px_cat_g1v2		-- good

SELECT
	DISTINCT maintenance
FROM silver.erp_px_cat_g1v2		-- good

