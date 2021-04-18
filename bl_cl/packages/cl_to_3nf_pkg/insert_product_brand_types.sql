CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_product_brand_types
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_product_brand_types';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_product_brand_types(brand_type_id, brand_type, update_dt) VALUES
        (-1, 'N/A', GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_product_brand_types';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_product_brand_types(brand_type_id, brand_type)
    SELECT NEXT VALUE FOR bl_3nf.dbo.products, brand_type FROM
    (SELECT  brand_type FROM cl_products
    GROUP BY brand_type)a;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_product_brand_types');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;