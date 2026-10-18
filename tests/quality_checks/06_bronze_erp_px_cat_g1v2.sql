/*
=======================================
Table: bronze.erp_px_cat_g1v2
=======================================
*/

-- ID: Check if there are duplicates
SELECT 
	id,
	COUNT(*)
FROM bronze.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1;	-- No Results

-- Check if there are white spaces
SELECT 
	id, cat, subcat, maintenance
FROM bronze.erp_px_cat_g1v2
WHERE 
	LENGTH(id) != LENGTH(TRIM(id)) OR
	LENGTH(cat) != LENGTH(TRIM(cat)) OR
	LENGTH(subcat) != LENGTH(TRIM(subcat)) OR
	LENGTH(maintenance) != LENGTH(TRIM(maintenance));		-- No Results

-- Check if the join works
SELECT
	*
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (SELECT DISTINCT prd_cat FROM silver.crm_prd_info); -- CO_PD

SELECT DISTINCT 
	prd_cat 
FROM silver.crm_prd_info WHERE prd_cat NOT IN (SELECT id FROM bronze.erp_px_cat_g1v2); -- CO_PE

SELECT * FROM bronze.erp_px_cat_g1v2 WHERE id = 'CO_PE'; -- No Result
SELECT	* FROM silver.crm_prd_info WHERE prd_cat = 'CO_PD'; -- No Result

	-- Solution: Change CO_PD to CO_PE
	SELECT 
		REPLACE(id, 'CO_PD', 'CO_PE') AS id
	FROM bronze.erp_px_cat_g1v2
	WHERE REPLACE(id, 'CO_PD', 'CO_PE') NOT IN (SELECT DISTINCT prd_cat FROM silver.crm_prd_info);

	
-- Low Cardinality Columns
SELECT
	DISTINCT cat
FROM bronze.erp_px_cat_g1v2		-- good

SELECT
	DISTINCT subcat
FROM bronze.erp_px_cat_g1v2		-- good

SELECT
	DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2		-- good

