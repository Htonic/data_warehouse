CREATE OR ALTER  PROCEDURE "3nf_to_dm".insert_products
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_dm.dbo.DIM_PRODUCTS';
    EXEC sys.sp_executesql @cmd;

	INSERT INTO bl_dm.dbo.dim_products (product_surrogate_id, product_id,product_natural_id, brand,
    brand_type, brand_id, brand_type_id,
    product_category_desc, product_category_id,
    start_date, end_date, is_active, update_dt)
    SELECT NEXT VALUE FOR bl_dm.dbo.SEQUENCE_PRODUCTS, cp.product_id,cp.product_natural_id,
    cpb.brand, cpbt.brand_type, cpb.brand_id, cpbt.brand_type_id,
    cpc.product_category_desc, cpc.product_category_id,
    cp.start_date, cp.end_date, cp.is_active, cp.update_dt
    FROM bl_3nf.dbo.ce_products cp 
    JOIN bl_3nf.dbo.ce_product_brand cpb ON cpb.brand_id = cp.brand_id
    JOIN bl_3nf.dbo.ce_product_brand_types cpbt 
    ON cpbt.brand_type_id = cpb.brand_type_id
    JOIN bl_3nf.dbo.ce_product_categories cpc 
    ON cpc.product_category_id = cp.product_category_id;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table DIM_PRODUCTS');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;