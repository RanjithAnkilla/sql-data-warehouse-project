-- Stored Procudure: Load Silver Layer (Bronze -> Silver)

-- This stored procudure performs the ETL process to populate the silver schema tables from the bronze schema

-- No parameters

-- EXEC silver.load-silver

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    PRINT '>> Truncating Table: silver.crm_cust_info'
    TRUNCATE TABLE silver.crm_cust_info
    PRINT '>> Inserting Data Into: silver.crm_cust_info'
    INSERT INTO silver.crm_cust_info
        (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
        )

    SELECT
        cust_id AS cst_id,
        cust_key AS cst_id,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE
        WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
        WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
        ELSE 'N/A'
    END AS cst_marital_status,
        CASE
        WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
        WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
        ELSE 'N/A'
    END AS cst_gndr,
        cst_create_date
    FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cst_create_date DESC) AS flag_last
        FROM bronze.crm_cust_info) as t
    WHERE flag_last = 1

    -----------------------------------------

    PRINT '>> Truncating Table: silver.crm_prd_info'
    TRUNCATE TABLE silver.crm_prd_info;
    PRINT '>> Inserting Data Into: silver.crm_prd_info'
    INSERT INTO silver.crm_prd_info
        (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
        )

    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
        SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
        prd_nm,
        ISNULL(prd_cost, 0) AS prd_cost,
        CASE UPPER(TRIM(prd_line))
        WHEN  'M' THEN 'Mountain'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'R' THEN 'Road'
        WHEN 'T' THEN 'Touring'
        ELSE 'N/A'
    END AS prd_line,
        CAST(prd_start_dt AS DATE) AS prd_start_dt,
        CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) AS DATE) AS prd_end_dt
    FROM bronze.crm_prd_info AS crm_prd

    ----------------------------------------------

    PRINT '>> Truncating Table: silver.crm_sales_details'
    TRUNCATE TABLE silver.crm_sales_details;
    PRINT '>> Inserting Data Into: silver.crm_sales_details'
    INSERT INTO silver.crm_sales_details
        (
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
        WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt,
        CASE
        WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,
        CASE
        WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt,
        CASE
        WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END As sls_sales,
        sls_quantity,
        CASE
        WHEN sls_price <= 0 OR sls_price IS NULL
        THEN sls_sales / ABS(sls_quantity)
        ELSE sls_price
    END As sls_price
    FROM bronze.crm_sales_details

    ---------------------------------------------

    PRINT '>> Truncating Table: silver.erp_cust_az12'
    TRUNCATE TABLE silver.erp_cust_az12;
    PRINT '>> Inserting Data Into: silver.erp_cust_az12'
    INSERT INTO silver.erp_cust_az12
        (cid, bdate, gen)

    SELECT
        CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
    END AS cid,
        CASE
        WHEN bdate > GETDATE() THEN NULL
        ELSE bdate
    END AS bdate,
        CASE 
        WHEN TRIM(UPPER(gen)) IN ('M', 'MALE') THEN 'Male'
        WHEN TRIM(UPPER(gen)) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'N/A'
    END AS gen
    FROM bronze.erp_cust_az12

    ----------------------------------------

    PRINT '>> Truncating Table: silver.erp_loc_a101'
    TRUNCATE TABLE silver.erp_loc_a101;
    PRINT '>> Inserting Data Into: silver.erp_loc_a101'
    INSERT INTO silver.erp_loc_a101
        (cid, cntry)
    SELECT
        REPLACE(cid, '-', '') AS cid,
        CASE
        WHEN TRIM(UPPER(cntry)) = 'DE' THEN 'Germany'
        WHEN TRIM(UPPER(cntry)) IN ('USA', 'US') THEN 'United States'
        WHEN TRIM(UPPER(cntry)) = ' ' OR cntry IS NULL THEN 'N/A'
        ELSE TRIM(cntry)
    END AS cntry
    FROM bronze.erp_loc_a101

    ---------------------------------------------------

    PRINT '>> Truncating Table: silver.erp_px_cat_g1v2'
    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2'
    INSERT INTO silver.erp_px_cat_g1v2
        (id, cat, subcat, maintence)
    SELECT
        id,
        cat,
        subcat,
        maintence
    FROM bronze.erp_px_cat_g1v2

--------------------------------------------------
END
