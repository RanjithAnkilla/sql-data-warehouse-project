-- DDL Silver Layer --
-- This script creates tables in the 'Silver' Schema, dropping existing tables.

IF OBJECT_ID('DataWarehouse.silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.silver.crm_cust_info;
GO
CREATE TABLE DataWarehouse.silver.crm_cust_info
(
    cst_id int,
    cst_key nvarchar(50),
    cst_firstname nvarchar(50),
    cst_lastname nvarchar(50),
    cst_marital_status nvarchar(50),
    cst_gndr nvarchar(50),
    cst_create_date date,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('DataWarehouse.silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.silver.crm_prd_info;
GO
CREATE TABLE DataWarehouse.silver.crm_prd_info
(
    prd_id int,
    cat_id NVARCHAR(50),
    prd_key NVARCHAR(50),
    prd_nm nvarchar(50),
    prd_cost int,
    prd_line nvarchar(50),
    prd_start_dt date,
    prd_end_dt date,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('DataWarehouse.silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.silver.crm_sales_details;
GO
CREATE TABLE DataWarehouse.silver.crm_sales_details
(
    sls_ord_num nvarchar(50),
    sls_prd_key nvarchar(50),
    sls_cust_id int,
    sls_order_dt date,
    sls_ship_dt date,
    sls_due_dt date,
    sls_sales int,
    sls_quantity int,
    sls_price int,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
)

/*
    The following tables erp_cust_az12, erp_loc_a101, and erp_px_cat_g1v2 are created in the silver layer of the DataWarehouse.
    It contains raw data ingested from the source systems without any transformations or cleaning.
    To ensure that we have a complete record of the source data for auditing and troubleshooting purposes.
*/
IF OBJECT_ID('DataWarehouse.silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.silver.erp_cust_az12;
GO
CREATE TABLE DataWarehouse.silver.erp_cust_az12
(
    cid nvarchar(50),
    bdate date,
    gen nvarchar(10),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('DataWarehouse.silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.silver.erp_loc_a101;
GO
CREATE TABLE DataWarehouse.silver.erp_loc_a101
(
    cid nvarchar(50),
    cntry nvarchar(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('DataWarehouse.silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.silver.erp_px_cat_g1v2;
GO
CREATE TABLE DataWarehouse.silver.erp_px_cat_g1v2
(
    id nvarchar(50),
    cat nvarchar(50),
    subcat nvarchar(50),
    maintence nvarchar(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
