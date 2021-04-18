CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_stores
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_stores';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_stores(store_id, store_number,
        store_name,street_address,
        phone_number,city_id,postcode_id, update_dt)
    VALUES
        (-1, 'N/A', 'N/A', 'N/A', 'N/A', -1, -1, GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_stores';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;

	INSERT INTO bl_3nf.dbo.ce_stores(store_id, store_number,
    store_name,street_address,
    phone_number,city_id,postcode_id, update_dt)
    SELECT NEXT VALUE FOR bl_3nf.dbo.stores, 
    CASE WHEN ss.store_number IS NULL THEN 'N/A' ELSE ss.store_number END AS store_number,
    CASE WHEN ss.store_name IS NULL THEN 'N/A' ELSE ss.store_name END AS store_name,
    CASE WHEN ss.street_address IS NULL THEN 'N/A' ELSE ss.street_address END AS street_address,
    CASE WHEN ss.phone_number IS NULL THEN 'N/A' ELSE ss.phone_number END AS phone_number,
    CASE WHEN ci.city_id IS NULL THEN -1 ELSE ci.city_id END AS city_id,
    CASE WHEN cp.postcode_id IS NULL THEN -1 ELSE cp.postcode_id END AS postcode_id,
    GETDATE() FROM cl_stores ss
        LEFT JOIN bl_3nf.dbo.ce_postcodes cp ON ss.postcode = cp.postcode
        LEFT JOIN bl_3nf.dbo.ce_cities ci ON ci.city_name = ss.city
        LEFT JOIN bl_3nf.dbo.ce_states cs ON cs.state_id = ci.state_id
        LEFT JOIN bl_3nf.dbo.ce_countries ccount ON ccount.country_id = cs.country_id
        WHERE cs.state_name = ss.state_province
        AND ccount.country_name = ss.country;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_stores');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;