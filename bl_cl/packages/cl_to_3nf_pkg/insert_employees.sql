CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_employees
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_employees';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_employees(employee_id, employee_natural_id, employee_name,
 employee_surname, age, email, phone, update_dt) VALUES 
         (-1, -1, 'N/A',
         'N/A', 0, 'N/A', 'N/A', GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_employees';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_employees(employee_id, employee_natural_id, employee_name,
    employee_surname, age, email, phone, update_dt)
    SELECT NEXT VALUE FOR bl_3nf.dbo.employees, employee_id, first_name,
    last_name, age, email, phone, GETDATE()
    FROM cl_employees;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_employees');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;