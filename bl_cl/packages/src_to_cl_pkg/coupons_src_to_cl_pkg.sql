CREATE OR ALTER  PROCEDURE src_to_cl.insert_coupons
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE cl_coupons';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO cl_coupons (coupon_id,coupon_desc,issued_quantity)
    SELECT CAST(TRIM(coupon_id) as INT), TRIM(coupon_desc),
    CAST(issued_quantity as INT) FROM sa_src.dbo.src_coupons;
    
    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table cl_coupons');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;