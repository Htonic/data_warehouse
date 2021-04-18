CREATE OR ALTER  PROCEDURE src_to_cl.insert_stores
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE cl_stores';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO cl_stores ( store_number, store_name, street_address, city,
    state_province, country, postcode, phone_number)
    SELECT trim(store_number), trim(store_name) as stname, trim(street_address), trim(city),
    trim(state_province), trim(country), CASE WHEN postcode IS NULL THEN NULL ELSE trim(postcode) END AS postcode,
    CASE WHEN phone_number IS NULL THEN NULL ELSE TRIM(phone_number) END AS phone_number
    FROM sa_src.dbo.src_stores;

    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table cl_stores');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;