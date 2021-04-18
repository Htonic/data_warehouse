CREATE OR ALTER  PROCEDURE src_to_cl.insert_employees
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE cl_employees';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO cl_employees (employee_id, first_name , last_name, email, phone, age)
        SELECT  CAST(employee_id AS INT), TRIM(first_name), TRIM(last_name),
    TRIM(email), TRIM(phone),CAST(age AS INT)  FROM sa_src.dbo.src_employees;

    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table cl_employees');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;