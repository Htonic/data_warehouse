CREATE OR ALTER  PROCEDURE "3nf_to_dm".sales_incremental_load
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = '';
DECLARE @last_load_date date;
BEGIN

	select @last_load_date  = MAX(update_dt) FROM bl_dm.dbo.fct_sales;

	UPDATE bl_dm.dbo.fct_sales
	SET 
	product_surrogate_id = prod.product_surrogate_id,
	customer_surrogate_id = cust.customer_surrogate_id,
    sale_date = cs.sale_date,
	coupon_surrogate_id = coup.coupon_surrogate_id,
	employee_surrogate_id = empl.employee_surrogate_id,
	payment_type_surrogate_id = paym.payment_type_surrogate_id,
	store_surrogate_id = stor.store_surrogate_id,
    quantity = cs.quantity,
	selling_price = cs.selling_price,
	cost_price = cs.cost_price,
	other_discount = cs.other_discount,
	coupon_discount = cs.coupon_discount,
	update_dt = cs.update_dt

	FROM bl_3nf.dbo.ce_sales cs 
	JOIN bl_dm.dbo.dim_coupons coup ON coup.coupon_id = cs.coupon_id 
	JOIN bl_dm.dbo.dim_customers cust ON cust.customer_id = cs.customer_id
	JOIN bl_dm.dbo.dim_employees empl ON empl.employee_id = cs.employee_id
	JOIN bl_dm.dbo.dim_products prod ON prod.product_id = cs.product_id
	JOIN bl_dm.dbo.dim_stores stor ON stor.store_id = cs.store_id
	JOIN bl_dm.dbo.dim_payment_types paym ON paym.payment_type_id = cs.payment_type_id
	WHERE cs.update_dt > @last_load_date and cs.sale_id IN (SELECT sale_id FROM bl_dm.dbo.fct_sales); 

    SET @event_message = CONCAT('Updated ',  @@ROWCOUNT, ' rows in table fct_sales');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
	
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
	JOIN bl_dm.dbo.dim_payment_types paym ON paym.payment_type_id = cs.payment_type_id
	WHERE cs.update_dt > @last_load_date and sale_id NOT IN (SELECT sale_id FROM bl_dm.dbo.fct_sales);
    


	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table fct_sales');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;