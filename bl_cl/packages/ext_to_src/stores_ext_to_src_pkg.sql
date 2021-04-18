CREATE OR ALTER  PROCEDURE ext_to_src.insert_stores
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE sa_src.dbo.src_stores';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO sa_src.dbo.src_stores ( store_number, store_name, street_address, city,
    state_province, country, postcode, phone_number)
    SELECT  store_number, store_name, street_address, city,
    state_province, country, postcode, phone_number FROM sa_src.dbo.external_stores ;
    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table src_stores');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;

