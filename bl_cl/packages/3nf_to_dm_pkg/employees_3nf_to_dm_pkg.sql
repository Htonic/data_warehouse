CREATE OR ALTER  PROCEDURE "3nf_to_dm".insert_employees
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_dm.dbo.DIM_EMPLOYEES';
    EXEC sys.sp_executesql @cmd;

    INSERT INTO bl_dm.dbo.dim_employees (employee_surrogate_id, employee_id,employee_natural_id,
    employee_name,
    employee_surname, age, email, phone, update_dt)
    SELECT NEXT VALUE FOR bl_dm.dbo.sequence_employees, employee_id,employee_natural_id,  employee_name,
    employee_surname, age, email, phone, update_dt
    FROM bl_3nf.dbo.ce_employees;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table DIM_EMPLOYEES');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;