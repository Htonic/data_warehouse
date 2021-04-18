CREATE OR ALTER  PROCEDURE ext_to_src.insert_employees
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE sa_src.dbo.src_employees';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO sa_src.dbo.src_employees (employee_id, first_name , last_name, email, phone, age)
    SELECT  employee_id, first_name , last_name, email, phone, age  FROM sa_src.dbo.external_employees;

    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table src_employees');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;