/*
========================================
-- Table: bronze.crm_prd_info
========================================
*/

-- 1) Remove Duplicates: Primary_key must be UNIQUE and NOT NULL 

SELECT 
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info
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
		bronze.crm_prd_info
	WHERE
		-- LENGTH(prd_key) != LENGTH(TRIM(prd_key));		-- None
		-- LENGTH(prd_nm) != LENGTH(TRIM(prd_nm));			-- None
		LENGTH(prd_line) != LENGTH(TRIM(prd_line));			-- There are
		


	-- Is the casing the same?

	SELECT
		*
	FROM
		bronze.crm_prd_info
	WHERE
		prd_key != UPPER(prd_key);			-- Same
		-- prd_nm != INITCAP(prd_nm);			-- No (There are abbreviations in some of them)
		-- prd_line != UPPER(prd_line);			-- Same



	-- Are there weird characters that have no sense in the column?

	SELECT 
		*
	FROM bronze.crm_prd_info
	WHERE 
		prd_key ~ '[^a-zA-Z0-9 -]';				-- None
		-- prd_nm ~ '[^a-zA-Z0-9 -]';			-- None 
		-- prd_line ~ '[^a-zA-Z0-9 ]';			-- None


	-- Checking the consistency of the values in low-cardinality columns

	SELECT
		DISTINCT prd_line
	FROM bronze.crm_prd_info;

	
	SELECT
		DISTINCT prd_line,
		CASE UPPER(TRIM(prd_line))
			WHEN  'M' THEN 'Mountain'
			WHEN  'R' THEN 'Road'
			WHEN  'S' THEN 'Other Sales'
			WHEN  'T' THEN 'Touring'
			ELSE 'n/a'
		END AS prd_line
	FROM bronze.crm_prd_info


	-- Checking for nulls and empty strings in other sting columns

	SELECT * 
	FROM bronze.crm_prd_info
	WHERE 
		prd_key IS NULL OR prd_nm IS NULL
		OR prd_key = '' OR prd_nm = ''	-- Result = None

/*
---------------------------------------
---------------------------------------
---------------------------------------
*/	

-- 3) Numeric Values

SELECT
	prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0

/*
---------------------------------------
---------------------------------------
---------------------------------------
*/	

-- 4) Dates


SELECT
	prd_key,
	COUNT(*) 
FROM bronze.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*) > 1


SELECT
	prd_key,
	prd_cost,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_key = 'CO-RF-FR-R38B-62'

/*
"prd_key"			"prd_cost"	"prd_start_dt"			"prd_end_dt"
"CO-RF-FR-R38B-62"	176			"2011-07-01 00:00:00"	"2007-12-28 00:00:00"
"CO-RF-FR-R38B-62"	170			"2012-07-01 00:00:00"	"2008-12-27 00:00:00"
"CO-RF-FR-R38B-62"	205			"2013-07-01 00:00:00"	

Dates make no sense (eg. start -> 2011, end -> 2007)
Also if we switch the two there will be an overlap 
		(eg. form 2007 to 2011 the cost = 176, and from 2008 to 2012 the cost = 170
		What about 2010, which cost?)

Solution: 
	the end date of the first history = start date of the next history - 1
*/

SELECT
	prd_key,
	prd_cost,
	prd_start_dt::DATE,
	(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt))::DATE - 1 AS prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_key = 'CO-RF-FR-R38B-62';



/*
---------------------------------------
---------------------------------------
---------------------------------------
*/	


-- Split Columns

SELECT 
	prd_key,
	SUBSTRING(prd_key, 1, 5) AS prd_cat,
	SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key
FROM bronze.crm_prd_info;


-- We can join this table with other tables
-- Let's make sure the join works

SELECT 
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS prd_cat,
	SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key
FROM 
	bronze.crm_prd_info
WHERE 
	-- REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN (SELECT id FROM bronze.erp_px_cat_g1v2)
	SUBSTRING(prd_key, 7, LENGTH(prd_key)) NOT IN (SELECT DISTINCT sls_prd_key FROM bronze.crm_sales_details)

-- CO_PE isn't in bronze.erp_px_cat_g1v2 
SELECT 
	id 
FROM bronze.erp_px_cat_g1v2 
WHERE id = 'CO_PE'

-- There are prd with no sales 
SELECT DISTINCT 
	sls_prd_key 
FROM bronze.crm_sales_details
WHERE sls_prd_key = 'FR-R92B-58'
