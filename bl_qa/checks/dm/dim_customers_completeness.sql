CREATE OR ALTER  PROCEDURE bl_qa.dim_customers_completeness
AS
DECLARE @failed_count INT;
DECLARE @failed_perc DECIMAL(18, 2);
DECLARE @status_id  INT;
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
		
    WITH nf as 
		(SELECT  cc.customer_id,cc.customer_natural_id,
    cag.age_range, cms.marital_status,
    cc.rented, cfs.family_size, cnof.no_of_child, 
    cc.income_bracket, cag.age_range_id, cnof.no_of_child_id,
    cfs.family_id, cms.marital_id, cc.update_dt
    FROM bl_3nf.dbo.ce_customers cc
    JOIN bl_3nf.dbo.ce_family_sizes cfs ON cfs.family_id = cc.family_id 
    JOIN bl_3nf.dbo.ce_no_of_childs cnof ON cnof.no_of_child_id = cc.no_of_child_id
    JOIN bl_3nf.dbo.ce_age_range cag ON cag.age_range_id = cc.age_range_id
    JOIN bl_3nf.dbo.ce_marital_statuses cms ON cms.marital_id = cc.marital_id),

	dm as (SELECT customer_id, customer_natural_id, age_range, marital_status,
				rented, family_size, no_of_child, income_bracket, age_range_id,
				no_of_child_id, family_size_id, marital_status_id, update_dt FROM bl_dm.dbo.dim_customers)

	SELECT @failed_count = count(*) FROM (select * from dm
	EXCEPT 
	SELECT * FROM nf)a;


	IF(@failed_count <> 0)
	  BEGIN
		WITH dm as (SELECT COUNT(*) as cnt_dm FROM bl_dm.dbo.dim_customers)
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
	SELECT 'Check completeness between bl_3nd and bl_dm for customers' as check_name,
	@failed_perc,
	(select check_type_id from bl_qa.dbo.check_type where check_type_name = 'ETL Check') as check_type_id,
	@status_id,
	(select priority_id from bl_qa.dbo.check_priority where priority_name = 'High') as priority_id,
	(select stage_id from bl_qa.dbo.stage where stage_name = 'bl_dm') as stage_id;


	SET @event_message = CONCAT('Check completeness between bl_3nd and bl_dm for customers finished with status_id: ', @status_id);
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;