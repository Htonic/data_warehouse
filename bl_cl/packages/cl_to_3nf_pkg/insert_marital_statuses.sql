CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_marital_statuses
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_marital_statuses';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_marital_statuses(marital_id, marital_status, update_dt) 
    VALUES
        (-1, 'N/A', GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_marital_statuses';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;

	INSERT INTO bl_3nf.dbo.ce_marital_statuses(marital_id, marital_status, update_dt)
    SELECT NEXT VALUE FOR bl_3nf.dbo.sequence_common_1, marital_status, GETDATE()  FROM
    (SELECT  marital_status FROM cl_customers
    GROUP BY marital_status)a
    WHERE marital_status IS NOT NULL;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_marital_statuses');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;