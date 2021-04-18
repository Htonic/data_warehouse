CREATE OR ALTER  PROCEDURE ext_to_src.insert_sales
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE sa_src.dbo.src_sales';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO sa_src.dbo.src_sales ( coupon_id, store_id, payment_type_id, employee_id,
    sale_date, customer_id, item_id, quantity,
    selling_price, other_discount, coupon_discount)
    SELECT coupon_id, store_id, payment_type_id, employee_id,
    "date", customer_id, item_id, quantity,selling_price, other_discount, coupon_discount
    FROM sa_src.dbo.external_customer_transaction;
    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table src_sales');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;

