CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_postcodes
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_postcodes';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_postcodes( postcode_id, postcode, update_dt) VALUES
    (-1, 'N/A', GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_postcodes';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_postcodes( postcode_id, postcode, update_dt )
        SELECT NEXT VALUE FOR bl_3nf.dbo.sequence_common_2, postcode, GETDATE() FROM
        (SELECT  postcode FROM cl_stores
        GROUP BY postcode)a
        WHERE postcode IS NOT NULL;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_postcodes');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;