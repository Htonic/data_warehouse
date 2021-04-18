CREATE OR ALTER  PROCEDURE src_to_cl.insert_products
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE cl_products';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO cl_products ( item_id, brand, brand_type, product_category)
    SELECT CAST(TRIM(item_id) AS INT),  CAST(TRIM(brand) AS INT), TRIM(brand_type),
     TRIM(product_category) FROM sa_src.dbo.src_products;

    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table cl_products');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;