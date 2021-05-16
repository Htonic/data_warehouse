CREATE OR ALTER  PROCEDURE bl_qa.dim_products_completeness
AS
DECLARE @failed_count INT;
DECLARE @failed_perc DECIMAL(18, 2);
DECLARE @status_id  INT;
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
		
    WITH nf as 
		(SELECT  cp.product_id,cp.product_natural_id,
    cpb.brand, cpbt.brand_type, cpb.brand_id, cpbt.brand_type_id,
    cpc.product_category_desc, cpc.product_category_id,
    cp.start_date, cp.end_date, cp.is_active, cp.update_dt
    FROM bl_3nf.dbo.ce_products cp 
    JOIN bl_3nf.dbo.ce_product_brand cpb ON cpb.brand_id = cp.brand_id
    JOIN bl_3nf.dbo.ce_product_brand_types cpbt 
    ON cpbt.brand_type_id = cpb.brand_type_id
    JOIN bl_3nf.dbo.ce_product_categories cpc 
    ON cpc.product_category_id = cp.product_category_id),

	dm as (SELECT  product_id,product_natural_id, brand,
    brand_type, brand_id, brand_type_id,
    product_category_desc, product_category_id,
    start_date, end_date, is_active, update_dt FROM bl_dm.dbo.dim_products)

	SELECT @failed_count = count(*) FROM 
	(select * from dm
	EXCEPT 
	SELECT * FROM nf)a;


	IF(@failed_count <> 0)
	  BEGIN
		WITH dm as (SELECT COUNT(*) as cnt_dm FROM bl_dm.dbo.dim_products)
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
	SELECT 'Check completeness between bl_3nd and bl_dm for products' as check_name,
	@failed_perc,
	(select check_type_id from bl_qa.dbo.check_type where check_type_name = 'ETL Check') as check_type_id,
	@status_id,
	(select priority_id from bl_qa.dbo.check_priority where priority_name = 'High') as priority_id,
	(select stage_id from bl_qa.dbo.stage where stage_name = 'bl_dm') as stage_id;


	SET @event_message = CONCAT('Check completeness between bl_3nd and bl_dm for products finished with status_id: ', @status_id);
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;