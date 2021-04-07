INSERT INTO ce_sales(sale_id, sale_date, product_id, customer_id, coupon_id,
    employee_id, payment_type_id, store_id, quantity, selling_price,
    other_discount, coupon_discount, cost_price, update_dt)
SELECT sales.NEXTVAL,sss.sale_date, cp.product_id, cc.customer_id, coup.coupon_id,
cempl.employee_id, cpt.payment_type_id, ce_str.store_id,
sss.quantity,sss.selling_price, sss.other_discount,
sss.coupon_discount, sss.cost_price,
TO_CHAR(SYSDATE, 'MM.DD.YYYY')
FROM bl_cl.cl_sales sss
JOIN ce_payment_types cpt ON cpt.payment_type_surrogate_id = sss.payment_type_id
JOIN ce_products cp ON cp.product_surrogate_id = sss.item_id
JOIN ce_customers cc ON cc.customer_surrogate_id = sss.customer_id
JOIN ce_coupons coup ON coup.coupon_surrogate_id = sss.coupon_id
JOIN ce_employees cempl ON cempl.employee_surrogate_id = sss.employee_id
JOIN bl_cl.store_id_temp str_tmp ON str_tmp.store_id_sales = sss.store_id
JOIN ce_stores ce_str ON ce_str.store_number = str_tmp.store_number;
COMMIT;
