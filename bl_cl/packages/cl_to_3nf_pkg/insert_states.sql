CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_states
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_states';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_states(state_id, state_name, country_id, update_dt) VALUES
    (-1, 'N/A', -1, GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_states';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_states(state_id, state_name, country_id, update_dt)
        SELECT NEXT VALUE FOR bl_3nf.dbo.sequence_common_2, state_province, 
        CASE WHEN cc.country_id IS NULL THEN -1 ELSE cc.country_id END AS country_id,
        GETDATE() FROM
        (SELECT  state_province, country FROM cl_stores
        GROUP BY state_province, country)a
        LEFT JOIN bl_3nf.dbo.ce_countries cc ON cc.country_name = A.country
        WHERE state_province IS NOT NULL;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_states');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;