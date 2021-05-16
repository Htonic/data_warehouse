CREATE OR ALTER  PROCEDURE bl_qa.cl_employees_completeness
AS
DECLARE @failed_count INT;
DECLARE @failed_perc DECIMAL(18, 2);
DECLARE @status_id  INT;
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
		
    WITH src as 
		(SELECT  CAST(employee_id AS INT) employee_id, TRIM(first_name) first_name, TRIM(last_name) last_name,
    TRIM(email) email, TRIM(phone) phone,CAST(age AS INT) age FROM sa_src.dbo.src_employees), 

	cl as (SELECT employee_id, first_name , last_name, email, phone, age FROM bl_cl.dbo.cl_employees)

	SELECT @failed_count = count(*) FROM (select * from cl
	EXCEPT 
	SELECT * FROM src)a;


	IF(@failed_count <> 0)
	  BEGIN
		WITH cl as (SELECT COUNT(*) as cnt_cl FROM bl_cl.dbo.cl_employees)
			SELECT @failed_perc  = ROUND(CAST(@failed_count AS decimal(18, 2)) / cnt_cl * 100, 2)  
			FROM cl;
		SELECT @status_id = status_id from bl_qa.dbo.check_status WHERE status_name = 'Failed';
	  END
	ELSE
	  BEGIN
		SET @failed_perc = 0.0;
		SELECT @status_id = status_id from bl_qa.dbo.check_status WHERE status_name = 'Passed';
	  END
	;
    
	INSERT INTO bl_qa.dbo.dq_checks(check_name, failed_perc,
						check_type_id, status_id, priority_id, stage_id)
	SELECT 'Check completeness between sa_src and bl_cl for employees' as check_name,
	@failed_perc,
	(select check_type_id from bl_qa.dbo.check_type where check_type_name = 'ETL Check') as check_type_id,
	@status_id,
	(select priority_id from bl_qa.dbo.check_priority where priority_name = 'High') as priority_id,
	(select stage_id from bl_qa.dbo.stage where stage_name = 'bl_cl') as stage_id;


	SET @event_message = CONCAT('Check completeness between sa_src and bl_cl for employees finished with status_id: ', @status_id);
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;