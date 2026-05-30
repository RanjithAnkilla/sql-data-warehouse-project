/*
    The following tables crm_cust_info, crm_prd_info, crm_sales_details are created in the bronze layer of the DataWarehouse.
    It contains raw data ingested from the source systems without any transformations or cleaning.
    To ensure that we have a complete record of the source data for auditing and troubleshooting purposes.
*/

-- Drop the table if it already exists
IF OBJECT_ID('DataWarehouse.bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.bronze.crm_cust_info;
GO

CREATE TABLE DataWarehouse.bronze.crm_cust_info
(
    cust_id int,
    cust_key nvarchar(50),
    cst_firstname nvarchar(50),
    cst_lastname nvarchar(50),
    cst_marital_status nvarchar(1),
    cst_gndr nvarchar(1),
    cst_create_date date
);

-- Drop the table if it already exists
IF OBJECT_ID('DataWarehouse.bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.bronze.crm_prd_info;
GO

CREATE TABLE DataWarehouse.bronze.crm_prd_info
(
    prd_id int,
    prd_key nvarchar(50),
    prd_nm nvarchar(50),
    prd_cost int,
    prd_line nvarchar(50),
    prd_start_dt datetime,
    prd_end_dt datetime
);

-- Drop the table if it already exists
IF OBJECT_ID('DataWarehouse.bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.bronze.crm_sales_details;
GO

CREATE TABLE DataWarehouse.bronze.crm_sales_details
(
    sls_ord_num nvarchar(50),
    sls_prd_key nvarchar(50),
    sls_cust_id int,
    sls_order_dt int,
    sls_ship_dt int,
    sls_due_dt int,
    sls_sales int,
    sls_quantity int,
    sls_price int
)

/*
    The following tables erp_cust_az12, erp_loc_a101, and erp_px_cat_g1v2 are created in the bronze layer of the DataWarehouse.
    It contains raw data ingested from the source systems without any transformations or cleaning.
    To ensure that we have a complete record of the source data for auditing and troubleshooting purposes.
*/
-- Drop the table if it already exists
IF OBJECT_ID('DataWarehouse.bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.bronze.erp_cust_az12;
GO

CREATE TABLE DataWarehouse.bronze.erp_cust_az12
(
    cid nvarchar(50),
    bdate date,
    gen nvarchar(10)
);

-- Drop the table if it already exists
IF OBJECT_ID('DataWarehouse.bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE DataWarehouse.bronze.crm_prd_info;
GO

CREATE TABLE DataWarehouse.bronze.erp_loc_a101
(
    cid nvarchar(50),
    cntry nvarchar(50)
);

CREATE TABLE DataWarehouse.bronze.erp_px_cat_g1v2
(
    id nvarchar(50),
    cat nvarchar(50),
    subcat nvarchar(50),
    maintence nvarchar(50)
);
