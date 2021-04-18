CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_family_sizes
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_family_sizes';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_family_sizes(family_id, family_size, update_dt) 
    VALUES
        (-1, 'N/A', GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_family_sizes';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_family_sizes(family_id, family_size, update_dt)
    SELECT NEXT VALUE FOR bl_3nf.dbo.sequence_common_1, family_size, GETDATE()  FROM
    (SELECT  family_size FROM cl_customers
    GROUP BY family_size)a
    WHERE family_size IS NOT NULL;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_family_sizes');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;