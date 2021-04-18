CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_sales
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_sales';
    EXEC sys.sp_executesql @cmd;
    
	INSERT INTO bl_3nf.dbo.ce_sales(sale_id,cl_sale_id, sale_date, product_id, customer_id, coupon_id,
    employee_id, payment_type_id, store_id, quantity, selling_price,
    other_discount, coupon_discount, cost_price, update_dt)
        SELECT NEXT VALUE FOR bl_3nf.dbo.sales, sss.cl_sale_id, sss.sale_date,
        CASE WHEN cp.product_id IS NULL THEN -1 ELSE cp.product_id END AS product_id,
        CASE WHEN cc.customer_id IS NULL THEN -1 ELSE  cc.customer_id END AS customer_id,
        CASE WHEN coup.coupon_id IS NULL THEN -1 ELSE coup.coupon_id END AS coupon_id,
        CASE WHEN cempl.employee_id IS NULL THEN -1 ELSE cempl.employee_id END AS employee_id,
        CASE WHEN cpt.payment_type_id IS NULL THEN -1 ELSE cpt.payment_type_id END AS payment_type_id,
        CASE WHEN ce_str.store_id IS NULL THEN -1 ELSE ce_str.store_id END AS store_id,
        sss.quantity,sss.selling_price, sss.other_discount,
        sss.coupon_discount, sss.cost_price,
        sss.update_dt
        FROM cl_sales sss
        LEFT JOIN bl_3nf.dbo.ce_payment_types cpt ON cpt.payment_type_natural_id = sss.payment_type_id
        LEFT JOIN bl_3nf.dbo.ce_products cp ON cp.product_natural_id = sss.item_id
        LEFT JOIN bl_3nf.dbo.ce_customers cc ON cc.customer_natural_id = sss.customer_id
        LEFT JOIN bl_3nf.dbo.ce_coupons coup ON coup.coupon_natural_id = sss.coupon_id
        LEFT JOIN bl_3nf.dbo.ce_employees cempl ON cempl.employee_natural_id = sss.employee_id
        LEFT JOIN store_id_temp str_tmp ON str_tmp.store_id_sales = sss.store_id
        LEFT JOIN bl_3nf.dbo.ce_stores ce_str ON ce_str.store_number = str_tmp.store_number;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_sales');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;