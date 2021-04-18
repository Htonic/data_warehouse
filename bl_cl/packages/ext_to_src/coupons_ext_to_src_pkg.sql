CREATE OR ALTER  PROCEDURE ext_to_src.insert_coupons
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE sa_src.dbo.src_coupons';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO sa_src.dbo.src_coupons (coupon_id,coupon_desc,issued_quantity)
            SELECT coupon_id, coupon_desc, issued_quantity FROM sa_src.dbo.external_coupons;
    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table src_coupons');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;