CREATE OR ALTER  PROCEDURE bl_qa.ce_sales_missed_stores
AS
DECLARE @failed_count INT;
DECLARE @failed_perc DECIMAL(18, 2);
DECLARE @status_id  INT;
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
    SELECT @failed_count = COUNT(*)  
		FROM bl_3nf.dbo.ce_sales
		WHERE store_id = -1 OR store_id IS NULL;
	
	SELECT  @failed_perc = ROUND(CAST(@failed_count AS decimal(18, 2)) / COUNT(*) * 100, 2)  
		FROM bl_3nf.dbo.ce_sales;


	IF(@failed_perc > 0.05)
	  BEGIN
		SELECT @status_id = status_id from bl_qa.dbo.check_status WHERE status_name = 'Failed';
	  END
	ELSE
	  BEGIN
		SELECT @status_id = status_id from bl_qa.dbo.check_status WHERE status_name = 'Passed';
	  END
	;
    
	INSERT INTO bl_qa.dbo.dq_checks(check_name, failed_perc,
						check_type_id, status_id, priority_id, stage_id)
	SELECT 'Check stores mapping for ce_sales' as check_name,
	@failed_perc,
	(select check_type_id from bl_qa.dbo.check_type where check_type_name = 'Data Quality Check') as check_type_id,
	@status_id,
	(select priority_id from bl_qa.dbo.check_priority where priority_name = 'High') as priority_id,
	(select stage_id from bl_qa.dbo.stage where stage_name = 'bl_3nf') as stage_id;


	SET @event_message = CONCAT('Check number of sales with undefined store: ', @status_id);
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;