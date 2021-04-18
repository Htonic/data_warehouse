CREATE OR ALTER  PROCEDURE ext_to_src.insert_products
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE sa_src.dbo.src_products';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO sa_src.dbo.src_products ( item_id, brand, brand_type, product_category)
        SELECT item_id, brand, brand_type, "category" FROM sa_src.dbo.external_item_data;
    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table src_products');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;