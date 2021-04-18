CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_no_of_childs
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_no_of_childs';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_no_of_childs(no_of_child_id, no_of_child, update_dt)
    VALUES
        (-1, 'N/A', GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_no_of_childs';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_no_of_childs(no_of_child_id, no_of_child, update_dt)
    SELECT NEXT VALUE FOR bl_3nf.dbo.sequence_common_1, no_of_children, GETDATE()  FROM
    (SELECT  no_of_children FROM cl_customers
    GROUP BY no_of_children)a
    WHERE no_of_children IS NOT NULL;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_no_of_childs');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;