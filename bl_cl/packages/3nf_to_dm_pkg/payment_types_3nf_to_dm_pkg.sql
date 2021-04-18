CREATE OR ALTER  PROCEDURE "3nf_to_dm".insert_payment_types
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_dm.dbo.DIM_PAYMENT_TYPES';
    EXEC sys.sp_executesql @cmd;

    INSERT INTO bl_dm.dbo.dim_payment_types (payment_type_surrogate_id, payment_type_id,payment_type_natural_id
    , payment_type_desc, update_dt)
    SELECT NEXT VALUE FOR bl_dm.dbo.SEQUENCE_PAYMENT_TYPES, payment_type_id,payment_type_natural_id, payment_type_desc, update_dt
    FROM bl_3nf.dbo.ce_payment_types;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table DIM_PAYMENT_TYPES');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;