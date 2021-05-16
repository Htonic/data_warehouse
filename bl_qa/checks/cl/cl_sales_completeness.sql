CREATE OR ALTER  PROCEDURE bl_qa.cl_sales_completeness
AS
DECLARE @failed_count INT;
DECLARE @failed_perc DECIMAL(18, 2);
DECLARE @status_id  INT;
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
		
    WITH src as 
		(SELECT CAST(coupon_id AS INT) coupon_id, CAST(store_id AS INT) store_id,
    CAST(payment_type_id AS INT) payment_type_id,CAST(employee_id AS INT) employee_id,
      CAST(sale_date as date) sale_date,CAST(customer_id AS INT) customer_id,
	  CAST(item_id AS INT) item_id, CAST(quantity AS INT) quantity,
      CAST(selling_price AS decimal(18, 2)) selling_price, CAST(selling_price AS decimal(18, 2)) * 0.75 cost_price,
      CAST(other_discount AS decimal(18, 2)) other_discount, 
      CAST(coupon_discount AS decimal(18, 2)) coupon_discount
    FROM sa_src.dbo.src_sales), 

	cl as (SELECT coupon_id, store_id, payment_type_id, employee_id,
      sale_date, customer_id, item_id, quantity,
      selling_price, cost_price, other_discount, coupon_discount FROM bl_cl.dbo.cl_sales)

	SELECT @failed_count = count(*) FROM (select * from cl
	EXCEPT 
	SELECT * FROM src)a;


	IF(@failed_count <> 0)
	  BEGIN
		WITH cl as (SELECT COUNT(*) as cnt_cl FROM bl_cl.dbo.cl_sales)
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
	SELECT 'Check completeness between sa_src and bl_cl for sales' as check_name,
	@failed_perc,
	(select check_type_id from bl_qa.dbo.check_type where check_type_name = 'ETL Check') as check_type_id,
	@status_id,
	(select priority_id from bl_qa.dbo.check_priority where priority_name = 'High') as priority_id,
	(select stage_id from bl_qa.dbo.stage where stage_name = 'bl_cl') as stage_id;


	SET @event_message = CONCAT('Check completeness between sa_src and bl_cl for sales finished with status_id: ', @status_id);
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;