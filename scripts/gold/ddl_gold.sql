/*
Create GOLD Views

Script Purpose:
    The Gold Layer represents the final facts and dimension tables (star schema)

    Each view performs transformations and combains data from silver layer to produce a clean, enriched and business ready dataset.
*/

USE DataWarehouse;
GO

CREATE OR ALTER VIEW gold.dim_customers
AS
    SELECT
        ROW_NUMBER() OVER (ORDER BY ci.cst_id) customer_key,
        ci.cst_id customer_id,
        ci.cst_key customer_number,
        ci.cst_firstname first_name,
        ci.cst_lastname last_name,
        cd.bdate birthdate,
        CASE
        WHEN ci.cst_gndr = 'N/A' THEN COALESCE(cd.gen, 'N/A')
        ELSE ci.cst_gndr
    END gender,
        ci.cst_marital_status marital_status,
        cl.cntry country,
        ci.cst_create_date create_date
    FROM silver.crm_cust_info ci
        LEFT JOIN silver.erp_cust_az12 cd
        ON ci.cst_key = cd.cid
        LEFT JOIN silver.erp_loc_a101 cl
        ON ci.cst_key = cl.cid

GO

CREATE OR ALTER VIEW gold.dim_products
AS
    WITH
        product_info
        AS
        (
            SELECT *
            FROM silver.crm_prd_info pi
            WHERE prd_end_dt IS NULL
            -- Filtering historical data
        )
    SELECT
        ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt, pi.prd_key) product_key,
        pi.prd_id product_id,
        pi.prd_key product_number,
        pi.prd_nm product_name,
        pi.cat_id category_id,
        pc.cat category,
        pc.subcat subcategory,
        pc.maintence maintenance,
        pi.prd_cost cost,
        pi.prd_line product_line,
        pi.prd_start_dt start_date
    FROM product_info pi
        LEFT JOIN silver.erp_px_cat_g1v2 pc
        ON pi.cat_id = pc.id

GO

CREATE OR ALTER VIEW gold.fact_sales
AS
    SELECT
        sd.sls_ord_num order_number,
        pr.product_key,
        cu.customer_key,
        sd.sls_order_dt order_date,
        sd.sls_ship_dt shipping_date,
        sd.sls_due_dt due_date,
        sd.sls_sales sales_amount,
        sd.sls_quantity quantity,
        sd.sls_price price
    FROM silver.crm_sales_details sd
        LEFT JOIN gold.dim_products pr
        ON pr.product_number = sd.sls_prd_key
        LEFT JOIN gold.dim_customers cu
        ON cu.customer_id = sd.sls_cust_id
