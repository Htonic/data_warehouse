CREATE OR ALTER  PROCEDURE "3nf_to_dm".insert_coupons
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_dm.dbo.dim_coupons';
    EXEC sys.sp_executesql @cmd;

    INSERT INTO bl_dm.dbo.dim_coupons (coupon_surrogate_id, coupon_id,coupon_natural_id, coupon_desc,
        issued_quantity, update_dt)
    SELECT NEXT VALUE FOR bl_dm.dbo.sequence_coupons, coupon_id,coupon_natural_id, coupon_desc, issued_quantity, update_dt
    FROM bl_3nf.dbo.ce_coupons;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table dim_coupons');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;