CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_cities
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_cities';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_cities(city_id, city_name, state_id, update_dt) VALUES
    (-1, 'N/A', -1, GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_cities';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_cities(city_id, city_name, state_id, update_dt)
        SELECT NEXT VALUE FOR bl_3nf.dbo.sequence_common_2, 
        city,
        CASE WHEN cs.state_id IS NULL THEN -1 ELSE cs.state_id END AS state_id,
        GETDATE()  FROM
        (SELECT  city, state_province FROM cl_stores
        GROUP BY city, state_province)a
        LEFT JOIN bl_3nf.dbo.ce_states cs ON cs.state_name = a.state_province
        WHERE city IS NOT NULL;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_cities');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;