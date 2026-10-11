/*
===============================================================================
Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Purpose:
    Load data from CRM and ERP CSV files into the Bronze layer.

Process:
    1. Record the batch start time.
    2. Truncate each Bronze table to remove existing rows.
    3. Load data from the corresponding CSV file using COPY.
    4. Measure and display the loading duration for each table.
    5. Display the total batch duration.
    6. Display error details.

Parameters:
    None.

Usage:
    CALL bronze.load_bronze();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
-- Dollar quoting marks the beginning and end of the procedure body.
-- allowing single quotes inside the body to be used normally, without doubling them to escape them.

DECLARE
    -- Variables used to measure loading durations.
    start_time        TIMESTAMP;
    end_time          TIMESTAMP;
    batch_start_time  TIMESTAMP;
    batch_end_time    TIMESTAMP;

BEGIN
    -- Record the actual time when the entire batch starts.
    -- clock_timestamp() returns the current time at each call.
    batch_start_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------------------------';


    -- =========================================================
    -- 1. CRM CUSTOMER INFO
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';

    -- Remove all existing rows while preserving the table structure.
    TRUNCATE TABLE bronze.crm_cust_info;

    RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';

    -- Load the CSV file into the table.
    -- HEADER TRUE skips the first row, assuming it contains headers.
    -- Without a column list, CSV fields must match the table's column order.
    COPY bronze.crm_cust_info
    FROM 'C:/Data_Analyst_Journey/Data with Baraa/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE
    );

    end_time := clock_timestamp();

    -- Subtract the timestamps to obtain an interval.
    -- EXTRACT(EPOCH ...) converts the interval into seconds.
    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- 2. CRM PRODUCT INFO
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';

    TRUNCATE TABLE bronze.crm_prd_info;

    RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';

    COPY bronze.crm_prd_info
    FROM 'C:/Data_Analyst_Journey/Data with Baraa/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- 3. CRM SALES DETAILS
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';

    TRUNCATE TABLE bronze.crm_sales_details;

    RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';

    COPY bronze.crm_sales_details
    FROM 'C:/Data_Analyst_Journey/Data with Baraa/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------------------------';


    -- =========================================================
    -- 4. ERP LOCATION
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';

    TRUNCATE TABLE bronze.erp_loc_a101;

    RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';

    COPY bronze.erp_loc_a101
    FROM 'C:/Data_Analyst_Journey/Data with Baraa/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- 5. ERP CUSTOMER
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';

    TRUNCATE TABLE bronze.erp_cust_az12;

    RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';

    COPY bronze.erp_cust_az12
    FROM 'C:/Data_Analyst_Journey/Data with Baraa/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- 6. ERP PRODUCT CATEGORY
    -- =========================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';

    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

    COPY bronze.erp_px_cat_g1v2
    FROM 'C:/Data_Analyst_Journey/Data with Baraa/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE
    );

    end_time := clock_timestamp();

    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- =========================================================
    -- BATCH COMPLETION
    -- =========================================================

    -- Record the time after all six tables have been processed.
    batch_end_time := clock_timestamp();

    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Loading Bronze Layer is Completed';

    RAISE NOTICE 'Total Load Duration: % seconds',
        EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));

    RAISE NOTICE '==========================================';


EXCEPTION
    -- WHEN OTHERS catches most runtime exceptions.
    WHEN OTHERS THEN

        RAISE NOTICE '==========================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';

        -- SQLERRM contains the human-readable error message.
        RAISE NOTICE 'Error Message: %', SQLERRM;

        -- SQLSTATE contains the standardized five-character error code.
        RAISE NOTICE 'SQLSTATE: %', SQLSTATE;

        RAISE NOTICE '==========================================';

        -- Re-raise the original error so the caller knows that the procedure failed.
        RAISE;

END;
$$;

-- Execute the stored procedure.
CALL bronze.load_bronze();
