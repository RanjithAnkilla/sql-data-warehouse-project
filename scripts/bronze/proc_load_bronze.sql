/*
------------------------------------------------------
Stored Procedure: Load Bornze Layer (Source -> Bronze)
------------------------------------------------------
Script Purpose:  
  This stored procedure loads data into the bronze sechema from external CSV files.
    It performs the following actions:
      1. It truncates the bronze tabel before inserting data.
      2. Uses "Bulk Insert" command to load data from CSV files to bronze layer tables.

Parameters: None.
  This stored procedure does not accept any parameters or return any values.

Usage:
  EXEC bronze.load_bronze
*/

use DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    BEGIN TRY
        DECLARE @start_time DATETIME, @end_time DATETIME,
        @b_layer_start_time DATETIME, @b_layer_end_time DATETIME;

        set @b_layer_start_time = GETDATE();
        PRINT '==============================================';
        PRINT 'Loading data into bronze layer...';
        PRINT '==============================================';
        PRINT '';
        PRINT '-----------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-----------------------------------------------';
        PRINT '';

        SET @start_time = GETDATE();
        PRINT '>> Truncating and loading data into: bronze.crm_cust_info...';
        TRUNCATE TABLE DataWarehouse.bronze.crm_cust_info;

        BULK INSERT DataWarehouse.bronze.crm_cust_info
        FROM 'D:\SQL Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-----------------------------------------------------'

        set @start_time = GETDATE();
        PRINT '';
        PRINT '>> Truncating and loading data into: bronze.crm_prd_info...';
        TRUNCATE TABLE DataWarehouse.bronze.crm_prd_info;

        BULK INSERT DataWarehouse.bronze.crm_prd_info
        FROM 'D:\SQL Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-----------------------------------------------------'

        SET @start_time = GETDATE();
        PRINT '';
        PRINT '>> Truncating and loading data into: bronze.crm_sales_details...';
        TRUNCATE TABLE DataWarehouse.bronze.crm_sales_details;

        BULK INSERT DataWarehouse.bronze.crm_sales_details
        FROM 'D:\SQL Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-----------------------------------------------------'

        SET @start_time = GETDATE();
        PRINT '';
        PRINT '-----------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-----------------------------------------------';

        PRINT '';
        PRINT '>> Truncating and loading data into: bronze.erp_cust_az12...';
        TRUNCATE TABLE DataWarehouse.bronze.erp_cust_az12;

        BULK INSERT DataWarehouse.bronze.erp_cust_az12
        FROM 'D:\SQL Project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-----------------------------------------------------'

        SET @start_time = GETDATE();
        PRINT '';
        PRINT '>> Truncating and loading data into: bronze.erp_loc_a101...';
        TRUNCATE TABLE DataWarehouse.bronze.erp_loc_a101;

        BULK INSERT DataWarehouse.bronze.erp_loc_a101
        FROM 'D:\SQL Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-----------------------------------------------------'

        SET @start_time = GETDATE();
        PRINT '';
        PRINT '>> Truncating and loading data into: bronze.erp_px_cat_g1v2...';
        TRUNCATE TABLE DataWarehouse.bronze.erp_px_cat_g1v2;

        BULK INSERT DataWarehouse.bronze.erp_px_cat_g1v2
        FROM 'D:\SQL Project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-----------------------------------------------------'

        set @b_layer_end_time = GETDATE()
        PRINT '>> Bronze Layer Load Duration: ' + CAST(DATEDIFF(SECOND, @b_layer_start_time, @b_layer_end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-----------------------------------------------------'
    END TRY
    BEGIN CATCH
        PRINT '===============================================';
        PRINT 'Error occurred while loading data into bronze layer:';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '===============================================';
    END CATCH
END
