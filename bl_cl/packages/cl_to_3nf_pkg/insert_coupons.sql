CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_coupons
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_coupons';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_coupons(coupon_id, coupon_natural_id, 
            coupon_desc, issued_quantity, update_dt) 
        VALUES
            (-1, -1, 'N/A', 0, GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_coupons';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_coupons  (coupon_id, coupon_natural_id, coupon_desc, issued_quantity, update_dt)
        SELECT NEXT VALUE FOR bl_3nf.dbo.sequence_common_1, coupon_id, coupon_desc, issued_quantity, GETDATE() 
        FROM cl_coupons;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_coupons');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;