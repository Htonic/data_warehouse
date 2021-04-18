CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_payment_types
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_payment_types';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_payment_types(payment_type_id, payment_type_natural_id,
 payment_type_desc, update_dt) VALUES
        (-1, -1, 'N/A', GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_payment_types';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


    INSERT INTO bl_3nf.dbo.ce_payment_types (payment_type_id, payment_type_natural_id, payment_type_desc, update_dt)
        SELECT NEXT VALUE FOR bl_3nf.dbo.sequence_common_1, cl.payment_type_id, cl.payment_type_desc, GETDATE()
        FROM cl_payment_types cl;

	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_payment_types');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;