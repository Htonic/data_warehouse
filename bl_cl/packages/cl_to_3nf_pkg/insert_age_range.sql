CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_age_range
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_age_range';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_age_range(age_range_id, age_range, update_dt) VALUES
        (-1, 'N/A', GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_age_range';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_age_range(age_range_id, age_range, update_dt)
    SELECT  NEXT VALUE FOR  bl_3nf.dbo.sequence_common_1, age_range, GETDATE() FROM
    (SELECT  age_range FROM cl_customers
    GROUP BY age_range)a
    WHERE age_range IS NOT NULL;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_age_range');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;