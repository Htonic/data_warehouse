CREATE OR ALTER  PROCEDURE bl_qa.dim_employees_duplicates
AS
DECLARE @failed_count INT;
DECLARE @failed_perc DECIMAL(18, 2);
DECLARE @status_id  INT;
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
		
    
	WITH duplicated_records as (
		SELECT COUNT(*) as cnt_dm FROM bl_dm.dbo.dim_employees group by employee_natural_id having count(*) > 1)
	SELECT @failed_count = COUNT(*) FROM duplicated_records;

	IF(@failed_count <> 0)
	  BEGIN
		WITH  dm as (SELECT COUNT(*) as cnt_dm FROM bl_dm.dbo.dim_employees)
			SELECT @failed_perc  = ROUND(CAST(@failed_count AS decimal(18, 2)) / cnt_dm * 100, 2)  
			FROM dm;
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
	SELECT 'Check duplicates for dim_employees' as check_name,
	@failed_perc,
	(select check_type_id from bl_qa.dbo.check_type where check_type_name = 'ETL Check') as check_type_id,
	@status_id,
	(select priority_id from bl_qa.dbo.check_priority where priority_name = 'High') as priority_id,
	(select stage_id from bl_qa.dbo.stage where stage_name = 'bl_dm') as stage_id;


	SET @event_message = CONCAT('Check duplicates for dim_employees finished with status_id: ', @status_id);
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;