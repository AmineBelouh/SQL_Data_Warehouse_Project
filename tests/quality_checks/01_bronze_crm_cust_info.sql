/*
=====================================================
-- Table: bronze.crm_cust_info
=====================================================
*/

-- 1) Remove Duplicates: Primary_key must be UNIQUE and NOT NULL 

SELECT 
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


SELECT 
	*
FROM
	(
		SELECT 
			*,
			COUNT(*) OVER(PARTITION BY cst_id) AS id_occurence,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS row_num
		FROM bronze.crm_cust_info
	)
WHERE id_occurence > 1;


/* 
	Start total records: 	18494
	Removing Null IDs: 		18490 (4 Nulls)
	Removing Duplicates: 	18484 (6 Duplicates)
	
	End Total records:		18484
*/
SELECT 
	*
FROM
	(
		SELECT 
			*,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS row_num
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
	)
WHERE row_num = 1;


-- Check one of the duplicated IDs to see if we kept the newest record
SELECT 
	*
FROM
	(
		SELECT 
			*,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS row_num
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
	)
WHERE row_num = 1 AND cst_id = 29433;


/*
---------------------------------------
---------------------------------------
---------------------------------------
*/

-- 2) String Values:

	-- Are There White Spaces?
	SELECT 
		*
	FROM bronze.crm_cust_info
	WHERE 
		LENGTH(cst_key) != LENGTH(TRIM(cst_key)); 						--> None
		-- LENGTH(cst_firstname) != LENGTH(TRIM(cst_firstname)); 			--> There are
		-- LENGTH(cst_lastname) != LENGTH(TRIM(cst_lastname)); 				--> There are 
		-- LENGTH(cst_marital_status) != LENGTH(TRIM(cst_marital_status)); 	--> None
		-- LENGTH(cst_gndr) != LENGTH(TRIM(cst_gndr)); 						--> None



	-- Is the Casing the same?
	SELECT 
		*
	FROM bronze.crm_cust_info
	WHERE 
		cst_key != UPPER(cst_key)							--> Same
		-- cst_firstname != INITCAP(cst_firstname) 				--> Same		
		-- cst_lastname != INITCAP(cst_lastname)				--> Issue		
		-- cst_marital_status != UPPER(cst_marital_status)		--> Same	
		-- cst_gndr != UPPER(cst_gndr)							--> Same

		AND cst_id IS NOT NULL;



	-- Are there weird characters that have no sense in the column?
	
	-- ~ checks whether the string matches a regular expression.  
	-- [^a-zA-Z0-9 ] matches any character that is not an English letter, a digit, or a space.
	-- This means: find rows containing at least one character that is not an English letter, a digit, or a space.

	SELECT 
		*
	FROM bronze.crm_cust_info
	WHERE 
		cst_key ~ '[^a-zA-Z0-9 ]'				--> None		
		-- cst_firstname ~ '[^a-zA-Z0-9 ]'			--> None. There is sense (eg. "José", "K.")
		-- cst_lastname ~ '[^a-zA-Z0-9 ]'			--> None. There is sense
		-- cst_marital_status ~ '[^a-zA-Z0-9 ]'		--> None
		-- cst_gndr ~ '[^a-zA-Z0-9 ]'				--> None
	
		AND cst_id IS NOT NULL;



	-- Checking the consistency of the values in low-cardinality columns

	SELECT
		DISTINCT cst_marital_status
	FROM bronze.crm_cust_info;

	SELECT
		DISTINCT cst_marital_status,
		CASE 
			WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			ELSE 'n/a'
		END AS cst_marital_status
	FROM bronze.crm_cust_info;


	SELECT
		DISTINCT cst_gndr
	FROM bronze.crm_cust_info;

	SELECT
		DISTINCT cst_gndr,
		CASE 
			WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			ELSE 'n/a'
		END AS cst_gndr
	FROM bronze.crm_cust_info;


	
-- Checking for Nulls in other string columns

	SELECT 
		*
	FROM bronze.crm_cust_info
	WHERE 
		cst_key IS NULL;			--> None
		-- cst_firstname IS NULL;	--> There are
		-- cst_lastname IS NULL;	--> There are
	
	
	SELECT 
		-- COALESCE(cst_firstname, 'n/a') AS cst_firstname
		-- COALESCE(cst_firstname, 'n/a') AS cst_lastname
	FROM bronze.crm_cust_info
	WHERE
		cst_firstname IS NULL;	
		-- cst_lastname IS NULL;
	
/*
---------------------------------------
---------------------------------------
---------------------------------------
*/

-- 3) Dates

-- We gave 'cst_create_date' the correct data type in Bronze DDL

-- Checking if there are Extreme Dates
SELECT
	MIN(cst_create_date),	
	MAX(cst_create_date)	
FROM bronze.crm_cust_info	--> No Extreme Dates


