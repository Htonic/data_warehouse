CREATE OR ALTER  PROCEDURE "3nf_to_dm".sales_initial_load
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_dm.dbo.fct_sales';
    EXEC sys.sp_executesql @cmd;

    INSERT INTO bl_dm.dbo.fct_sales (sale_id, product_surrogate_id, customer_surrogate_id,
    sale_date, coupon_surrogate_id, employee_surrogate_id, payment_type_surrogate_id, store_surrogate_id,
    quantity, selling_price, cost_price, other_discount, coupon_discount, update_dt)
	
	SELECT sale_id, prod.product_surrogate_id, cust.customer_surrogate_id,
	cs.sale_date, coup.coupon_surrogate_id, empl.employee_surrogate_id, paym.payment_type_surrogate_id,
	stor.store_surrogate_id, cs.quantity, cs.selling_price, cs.cost_price,
	cs.other_discount, cs.coupon_discount, cs.update_dt
	FROM bl_3nf.dbo.ce_sales cs 
	JOIN bl_dm.dbo.dim_coupons coup ON coup.coupon_id = cs.coupon_id 
	JOIN bl_dm.dbo.dim_customers cust ON cust.customer_id = cs.customer_id
	JOIN bl_dm.dbo.dim_employees empl ON empl.employee_id = cs.employee_id
	JOIN bl_dm.dbo.dim_products prod ON prod.product_id = cs.product_id
	JOIN bl_dm.dbo.dim_stores stor ON stor.store_id = cs.store_id
	JOIN bl_dm.dbo.dim_payment_types paym ON paym.payment_type_id = cs.payment_type_id;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table fct_sales');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;