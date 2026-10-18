/*
=================================================
Table: silver.crm_cust_info
=================================================
*/

-- 1) Duplicates: Primary_key must be UNIQUE and NOT NULL 

SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

/*
---------------------------------------
---------------------------------------
---------------------------------------
*/

-- 2) String Values:

	-- Are There White Spaces?
SELECT 
	*
FROM silver.crm_cust_info
WHERE 
	LENGTH(cst_key) != LENGTH(TRIM(cst_key)) OR 						
	LENGTH(cst_firstname) != LENGTH(TRIM(cst_firstname)) OR			
	LENGTH(cst_lastname) != LENGTH(TRIM(cst_lastname)) OR				
	LENGTH(cst_marital_status) != LENGTH(TRIM(cst_marital_status)) OR	
	LENGTH(cst_gndr) != LENGTH(TRIM(cst_gndr)); 						



	-- Is the Casing the same?
SELECT 
	*
FROM silver.crm_cust_info
WHERE 
	(
		cst_key != UPPER(cst_key) OR						
		cst_firstname != INITCAP(cst_firstname) OR						
		cst_lastname != INITCAP(cst_lastname) 				
	)
	
	AND cst_id IS NOT NULL;


	-- Checking the consistency of the values in low-cardinality columns
	SELECT
		cst_marital_status
	FROM silver.crm_cust_info;

	SELECT
		DISTINCT cst_gndr
	FROM silver.crm_cust_info;


	-- Checking for Nulls in other columns

	SELECT 
		*
	FROM silver.crm_cust_info
	WHERE 
		cst_key IS NULL OR		
		cst_firstname IS NULL OR
		cst_lastname IS NULL;
