INSERT INTO bl_dm.fct_sales (sale_id, product_id, customer_id,
    date_of_sale, coupon_id, employee_id, payment_type_id, store_id,
    quantity, selling_price, cost_price, other_discount, coupon_discount)
SELECT bl_dm.sequence_sales.nextval, prod.product_id, cust.customer_id,
cs.sale_date, coup.coupon_id, empl.employee_id, paym.payment_type_id,
stor.store_id, cs.quantity, cs.selling_price, cs.cost_price,
cs.other_discount, cs.coupon_discount
FROM BL_3NF.ce_sales cs 
JOIN bl_dm.dim_coupons coup ON coup.coupon_surrogate_id = cs.coupon_id 
JOIN bl_dm.dim_customers cust ON cust.customer_surrogate_id = cs.customer_id
JOIN bl_dm.dim_employees empl ON empl.employee_surrogate_id = cs.employee_id
JOIN bl_dm.dim_products prod ON prod.product_surrogate_id = cs.product_id
JOIN bl_dm.dim_stores stor ON stor.store_surrogate_id = cs.store_id
JOIN bl_dm.dim_payment_types paym ON paym.payment_type_surrogate_id = cs.payment_type_id;
COMMIT;
