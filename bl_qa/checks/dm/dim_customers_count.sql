CREATE OR ALTER  PROCEDURE bl_qa.dim_customers_count
AS
DECLARE @failed_count INT;
DECLARE @failed_perc DECIMAL(18, 2);
DECLARE @status_id  INT;
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
		
    WITH nf as (SELECT COUNT(*) as cnt_nf FROM bl_3nf.dbo.ce_customers),
	dm as (SELECT COUNT(*) as cnt_dm FROM bl_dm.dbo.dim_customers)
	SELECT @failed_count = (cnt_nf - cnt_dm) FROM nf, dm;

	IF(@failed_count <> 0)
	  BEGIN
		WITH nf as (SELECT COUNT(*) as cnt_nf FROM bl_3nf.dbo.ce_customers),
			dm as (SELECT COUNT(*) as cnt_dm FROM bl_dm.dbo.dim_customers)
			SELECT @failed_perc  = ROUND(CAST(cnt_dm AS decimal(18, 2)) / cnt_nf * 100, 2)  
			FROM nf, dm;
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
	SELECT 'Check counts between bl_3nd and bl_dm for customers' as check_name,
	@failed_perc,
	(select check_type_id from bl_qa.dbo.check_type where check_type_name = 'ETL Check') as check_type_id,
	@status_id,
	(select priority_id from bl_qa.dbo.check_priority where priority_name = 'High') as priority_id,
	(select stage_id from bl_qa.dbo.stage where stage_name = 'bl_dm') as stage_id;


	SET @event_message = CONCAT('Check counts between bl_3nd and bl_dm for customers finished with status_id: ', @status_id);
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;