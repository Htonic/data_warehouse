CREATE OR ALTER  PROCEDURE bl_qa.dim_stores_completeness
AS
DECLARE @failed_count INT;
DECLARE @failed_perc DECIMAL(18, 2);
DECLARE @status_id  INT;
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
		
    WITH nf as 
		(SELECT  cs.store_id, cs.store_number, cs.store_name,
    cs.street_address, ci.city_name, cst.state_name, cc.country_name, cp.postcode,
    cs.phone_number, ci.city_id, cst.state_id, cc.country_id, cp.postcode_id, cs.update_dt
    FROM bl_3nf.dbo.ce_stores cs
    JOIN bl_3nf.dbo.ce_cities ci ON ci.city_id = cs.city_id
    JOIN bl_3nf.dbo.ce_states cst ON cst.state_id = ci.state_id
    JOIN bl_3nf.dbo.ce_countries cc ON cc.country_id = cst.country_id
    JOIN bl_3nf.dbo.ce_postcodes cp ON cp.postcode_id = cs.postcode_id),

	dm as (SELECT store_id, store_number, store_name,
    street_address, city_name, state_or_province, country_name, postcode, phone_number, 
    city_id, state_id, country_id, postcode_id, update_dt FROM bl_dm.dbo.dim_stores)

	SELECT @failed_count = count(*) FROM (select * from dm
	EXCEPT 
	SELECT * FROM nf)a;


	IF(@failed_count <> 0)
	  BEGIN
		WITH dm as (SELECT COUNT(*) as cnt_dm FROM bl_dm.dbo.dim_stores)
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
	SELECT 'Check completeness between bl_3nd and bl_dm for stores' as check_name,
	@failed_perc,
	(select check_type_id from bl_qa.dbo.check_type where check_type_name = 'ETL Check') as check_type_id,
	@status_id,
	(select priority_id from bl_qa.dbo.check_priority where priority_name = 'High') as priority_id,
	(select stage_id from bl_qa.dbo.stage where stage_name = 'bl_dm') as stage_id;


	SET @event_message = CONCAT('Check completeness between bl_3nd and bl_dm for stores finished with status_id: ', @status_id);
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;