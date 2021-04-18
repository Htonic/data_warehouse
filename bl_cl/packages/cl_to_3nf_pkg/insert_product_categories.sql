CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_product_categories
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_product_categories';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_product_categories(product_category_id,
        product_category_desc, update_dt)
    VALUES
        (-1, 'N/A', GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_product_categories';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_product_categories(product_category_id, product_category_desc, update_dt)
    SELECT NEXT VALUE FOR bl_3nf.dbo.products, product_category, GETDATE() FROM
    (SELECT  product_category FROM cl_products
    GROUP BY product_category)a;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_product_categories');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;