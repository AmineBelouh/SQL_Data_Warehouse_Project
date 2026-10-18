/*
=====================================
Table: silver.crm_prd_info
=====================================
*/

SELECT * FROM silver.crm_prd_info;

-- 1) Duplicates: Primary_key must be UNIQUE and NOT NULL 

SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL; 	-- No Results


/*
---------------------------------------
---------------------------------------
---------------------------------------
*/


-- 2) Strings

	-- Are There White Spaces?

	SELECT
		*
	FROM
		silver.crm_prd_info
	WHERE
		-- LENGTH(prd_key) != LENGTH(TRIM(prd_key));		-- None
		-- LENGTH(prd_nm) != LENGTH(TRIM(prd_nm));			-- None
		LENGTH(prd_line) != LENGTH(TRIM(prd_line));			-- None
		


	-- Is the casing the same?

	SELECT
		*
	FROM
		silver.crm_prd_info
	WHERE
		prd_key != UPPER(prd_key);			-- Same
		-- prd_nm != INITCAP(prd_nm);			-- Same
		-- prd_line != UPPER(prd_line);			-- Same



	-- Checking the consistency of the values in low-cardinality columns

	SELECT
		DISTINCT prd_line
	FROM silver.crm_prd_info;

	
	SELECT
		DISTINCT prd_line
	FROM silver.crm_prd_info
	

/*
---------------------------------------
---------------------------------------
---------------------------------------
*/	

-- 3) Numeric Values

SELECT
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0

/*
---------------------------------------
---------------------------------------
---------------------------------------
*/	

-- 4) Dates

SELECT
	prd_key,
	prd_cost,
	prd_start_dt::DATE,
	(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt))::DATE - 1 AS prd_end_dt
FROM silver.crm_prd_info
WHERE prd_key = 'FR-R38B-62';



/*
---------------------------------------
---------------------------------------
---------------------------------------
*/	


-- Derived Columns

SELECT 
	prd_key,
	prd_cat
FROM 
	silver.crm_prd_info
WHERE 
	-- prd_cat NOT IN (SELECT id FROM bronze.erp_px_cat_g1v2)
	prd_key NOT IN (SELECT DISTINCT sls_prd_key FROM bronze.crm_sales_details)
