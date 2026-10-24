/*
===============================================================================
Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.

Actions Performed:
    - Truncates each Silver table before loading it.
    - Cleans, standardizes, and transforms data from Bronze.
    - Displays the loading duration for each table and the whole batch.
    - Reports errors to the caller.

Parameters:
    None.

Usage:
    CALL silver.load_silver();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
-- Dollar quoting marks the beginning and end of the procedure body.
-- It lets us use single quotes normally inside the body.

DECLARE
    -- Timestamps used to calculate elapsed loading time.
    start_time        TIMESTAMP;
    end_time          TIMESTAMP;
    batch_start_time  TIMESTAMP;
    batch_end_time    TIMESTAMP;

BEGIN
    -- Record the actual time when the whole batch begins.
    batch_start_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Silver Layer';
    RAISE NOTICE '================================================';


    -- =========================================================
    -- 1. CRM CUSTOMER INFO
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;

    RAISE NOTICE '>> Inserting Transformed Data Into: silver.crm_cust_info';

    INSERT INTO silver.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )
    SELECT
        cst_id,
        cst_key,

        COALESCE(NULLIF(TRIM(cst_firstname), ''), 'n/a') AS cst_firstname,
        COALESCE(NULLIF(TRIM(cst_lastname), ''), 'n/a') AS cst_lastname,

        CASE
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            ELSE 'n/a'
        END AS cst_marital_status,

        CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            ELSE 'n/a'
        END AS cst_gndr,

        cst_create_date

    FROM (

        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY cst_id
                ORDER BY cst_create_date DESC
            ) AS row_num

        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL

    ) AS ranked_customers

    WHERE row_num = 1;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- 2. CRM PRODUCT INFO
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info;

    RAISE NOTICE '>> Inserting Transformed Data Into: silver.crm_prd_info';

    INSERT INTO silver.crm_prd_info (
        prd_id,
        prd_cat,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,

        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS prd_cat,
        SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,

        prd_nm,

        COALESCE(prd_cost, 0) AS prd_cost,

        CASE UPPER(TRIM(prd_line))
            WHEN 'M' THEN 'Mountain'
            WHEN 'R' THEN 'Road'
            WHEN 'S' THEN 'Other Sales'
            WHEN 'T' THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,

        prd_start_dt::DATE,

        (LEAD(prd_start_dt) OVER (
            PARTITION BY prd_key
            ORDER BY prd_start_dt
        ))::DATE - 1 AS prd_end_dt

    FROM bronze.crm_prd_info;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- 3. CRM SALES DETAILS
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details;

    RAISE NOTICE '>> Inserting Transformed Data Into: silver.crm_sales_details';

    INSERT INTO silver.crm_sales_details (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,

        CASE
            WHEN sls_order_dt = 0
                 OR LENGTH(sls_order_dt::VARCHAR) < 8 THEN NULL
            ELSE sls_order_dt::VARCHAR(50)::DATE
        END AS sls_order_dt,

        CASE
            WHEN sls_ship_dt = 0
                 OR LENGTH(sls_ship_dt::VARCHAR) < 8 THEN NULL
            ELSE sls_ship_dt::VARCHAR(50)::DATE
        END AS sls_ship_dt,

        CASE
            WHEN sls_due_dt = 0
                 OR LENGTH(sls_due_dt::VARCHAR) < 8 THEN NULL
            ELSE sls_due_dt::VARCHAR(50)::DATE
        END AS sls_due_dt,

        CASE
            WHEN sls_sales <= 0
                 OR sls_sales IS NULL
                 OR sls_sales != ABS(sls_price) * sls_quantity
            THEN ABS(sls_price) * sls_quantity
            ELSE sls_sales
        END AS sls_sales,

        sls_quantity,

        CASE
            WHEN sls_price <= 0 OR sls_price IS NULL
            THEN sls_sales / NULLIF(sls_quantity, 0)
            ELSE sls_price
        END AS sls_price

    FROM bronze.crm_sales_details;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- 4. ERP CUSTOMER
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: silver.erp_cust_az12';
    TRUNCATE TABLE silver.erp_cust_az12;

    RAISE NOTICE '>> Inserting Transformed Data Into: silver.erp_cust_az12';

    INSERT INTO silver.erp_cust_az12 (
        cid,
        bdate,
        gen
    )
    SELECT

        CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
            ELSE cid
        END AS cid,

        -- Set birth dates to NULL if the person is younger than 18.
        CASE
            WHEN bdate > (CURRENT_DATE - INTERVAL '18 years')::DATE
            THEN NULL
            ELSE bdate
        END AS bdate,

        CASE
            WHEN UPPER(TRIM(gen)) IN ('MALE', 'M') THEN 'Male'
            WHEN UPPER(TRIM(gen)) IN ('FEMALE', 'F') THEN 'Female'
            ELSE 'n/a'
        END AS gen

    FROM bronze.erp_cust_az12;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- 5. ERP LOCATION
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: silver.erp_loc_a101';
    TRUNCATE TABLE silver.erp_loc_a101;

    RAISE NOTICE '>> Inserting Transformed Data Into: silver.erp_loc_a101';

    INSERT INTO silver.erp_loc_a101 (
        cid,
        cntry
    )
    SELECT

        REPLACE(cid, '-', '') AS cid,

        CASE
            WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES')
                THEN 'United States'
            WHEN UPPER(TRIM(cntry)) IN ('FR', 'FRANCE')
                THEN 'France'
            WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY')
                THEN 'Germany'
            WHEN UPPER(TRIM(cntry)) IN ('UK', 'UNITED KINGDOM')
                THEN 'United Kingdom'
            WHEN UPPER(TRIM(cntry)) = 'AUSTRALIA'
                THEN 'Australia'
            WHEN UPPER(TRIM(cntry)) = 'CANADA'
                THEN 'Canada'
            ELSE 'n/a'
        END AS cntry

    FROM bronze.erp_loc_a101;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- 6. ERP PRODUCT CATEGORY
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: silver.erp_px_cat_g1v2';
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    RAISE NOTICE '>> Inserting Transformed Data Into: silver.erp_px_cat_g1v2';

    INSERT INTO silver.erp_px_cat_g1v2 (
        id,
        cat,
        subcat,
        maintenance
    )
    SELECT
        REPLACE(id, 'CO_PD', 'CO_PE') AS id,
        cat,
        subcat,
        maintenance
    FROM bronze.erp_px_cat_g1v2;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- BATCH COMPLETION
    -- =========================================================

    batch_end_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Silver Layer is Completed';
    RAISE NOTICE 'Total Load Duration: % seconds',
        EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '================================================';


EXCEPTION
    -- WHEN OTHERS catches most runtime errors in this block.
    WHEN OTHERS THEN

        RAISE NOTICE '================================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING SILVER LAYER';

        -- SQLERRM contains the readable error message.
        RAISE NOTICE 'Error Message: %', SQLERRM;

        -- SQLSTATE contains the standardized five-character error code.
        RAISE NOTICE 'SQLSTATE: %', SQLSTATE;

        RAISE NOTICE '================================================';

        -- Re-raise the original error so the caller knows the load failed.
        RAISE;

END;
$$;

-- Execute the stored procedure.
CALL silver.load_silver();
