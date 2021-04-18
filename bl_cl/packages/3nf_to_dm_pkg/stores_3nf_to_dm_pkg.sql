CREATE OR ALTER  PROCEDURE "3nf_to_dm".insert_stores
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_dm.dbo.dim_stores';
    EXEC sys.sp_executesql @cmd;

	INSERT INTO bl_dm.dbo.dim_stores (store_surrogate_id, store_id, store_number, store_name,
    street_address, city_name, state_or_province, country_name, postcode, phone_number, 
    city_id, state_id, country_id, postcode_id, update_dt)
    SELECT NEXT VALUE FOR   bl_dm.dbo.SEQUENCE_STORES, cs.store_id, cs.store_number, cs.store_name,
    cs.street_address, ci.city_name, cst.state_name, cc.country_name, cp.postcode,
    cs.phone_number, ci.city_id, cst.state_id, cc.country_id, cp.postcode_id, cs.update_dt
    FROM bl_3nf.dbo.ce_stores cs
    JOIN bl_3nf.dbo.ce_cities ci ON ci.city_id = cs.city_id
    JOIN bl_3nf.dbo.ce_states cst ON cst.state_id = ci.state_id
    JOIN bl_3nf.dbo.ce_countries cc ON cc.country_id = cst.country_id
    JOIN bl_3nf.dbo.ce_postcodes cp ON cp.postcode_id = cs.postcode_id;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table dim_stores');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;