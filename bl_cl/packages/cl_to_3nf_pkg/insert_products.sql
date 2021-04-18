CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_products
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_products';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_products(product_id, product_natural_id, brand_id,
        product_category_id,start_date, end_date, is_active, update_dt) VALUES
        (-1,-1, -1, -1, '12.12.1970','12.12.1970', 'N', GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_products';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_products(product_id, product_natural_id, brand_id,
    product_category_id,start_date, is_active, update_dt)
    SELECT NEXT VALUE FOR bl_3nf.dbo.products, item_id, pb.brand_id,
    cpc.product_category_id,
    GETDATE(), '1', insert_date FROM cl_products sss
    LEFT JOIN bl_3nf.dbo.ce_product_brand pb ON pb.brand = sss.brand
    LEFT JOIN bl_3nf.dbo.ce_product_categories cpc ON cpc.product_category_desc = sss.product_category
    LEFT JOIN bl_3nf.dbo.ce_product_brand_types cpbt ON cpbt.brand_type_id = pb.brand_type_id
    WHERE cpbt.brand_type = sss.brand_type;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_products');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;