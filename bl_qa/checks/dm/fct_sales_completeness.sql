CREATE OR ALTER  PROCEDURE bl_qa.fct_sales_completeness
AS
DECLARE @failed_count INT;
DECLARE @failed_perc DECIMAL(18, 2);
DECLARE @status_id  INT;
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
		
    WITH nf as 
		(SELECT  prod.product_surrogate_id, cust.customer_surrogate_id,
	cs.sale_date, coup.coupon_surrogate_id, empl.employee_surrogate_id, paym.payment_type_surrogate_id,
	stor.store_surrogate_id, cs.quantity, cs.selling_price, cs.cost_price,
	cs.other_discount, cs.coupon_discount, cs.update_dt
	FROM bl_3nf.dbo.ce_sales cs 
	JOIN bl_dm.dbo.dim_coupons coup ON coup.coupon_id = cs.coupon_id 
	JOIN bl_dm.dbo.dim_customers cust ON cust.customer_id = cs.customer_id
	JOIN bl_dm.dbo.dim_employees empl ON empl.employee_id = cs.employee_id
	JOIN bl_dm.dbo.dim_products prod ON prod.product_id = cs.product_id
	JOIN bl_dm.dbo.dim_stores stor ON stor.store_id = cs.store_id
	JOIN bl_dm.dbo.dim_payment_types paym ON paym.payment_type_id = cs.payment_type_id),

	dm as (SELECT product_surrogate_id, customer_surrogate_id,
    sale_date, coupon_surrogate_id, employee_surrogate_id, payment_type_surrogate_id, store_surrogate_id,
    quantity, selling_price, cost_price, other_discount, coupon_discount, update_dt FROM bl_dm.dbo.fct_sales)

	SELECT @failed_count = count(*) FROM (select * from dm
	EXCEPT 
	SELECT * FROM nf)a;


	IF(@failed_count <> 0)
	  BEGIN
		WITH dm as (SELECT COUNT(*) as cnt_dm FROM bl_dm.dbo.fct_sales)
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
	SELECT 'Check completeness between bl_3nd and bl_dm for sales' as check_name,
	@failed_perc,
	(select check_type_id from bl_qa.dbo.check_type where check_type_name = 'ETL Check') as check_type_id,
	@status_id,
	(select priority_id from bl_qa.dbo.check_priority where priority_name = 'High') as priority_id,
	(select stage_id from bl_qa.dbo.stage where stage_name = 'bl_dm') as stage_id;


	SET @event_message = CONCAT('Check completeness between bl_3nd and bl_dm for sales finished with status_id: ', @status_id);
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;