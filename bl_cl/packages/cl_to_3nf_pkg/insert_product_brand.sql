CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_product_brand
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_product_brand';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_product_brand(brand_id, brand, brand_type_id, update_dt) VALUES
        (-1, -1, -1, GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_product_brand';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_product_brand(brand_id, brand, brand_type_id)
    SELECT NEXT VALUE FOR bl_3nf.dbo.products, a.brand, cpbt.brand_type_id FROM
    (SELECT  brand, brand_type FROM cl_products
    GROUP BY brand_type, brand)a
    LEFT JOIN bl_3nf.dbo.ce_product_brand_types cpbt on cpbt.brand_type = a.brand_type;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_product_brand');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;