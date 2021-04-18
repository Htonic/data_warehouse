CREATE OR ALTER  PROCEDURE ext_to_src.insert_payment_types
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE sa_src.dbo.src_payment_types';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO sa_src.dbo.src_payment_types(payment_type_id, payment_type_desc)
        SELECT payment_type_id, payment_type_desc FROM sa_src.dbo.external_payment_types;
    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table src_payment_types');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;