CREATE OR REPLACE PACKAGE bl_cl.sales_cl_to_3nf_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_sales;
    PROCEDURE merge_sales;

END sales_cl_to_3nf_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.sales_cl_to_3nf_pkg
IS
    PROCEDURE insert_sales
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE BL_3NF.ce_sales';
    
    INSERT INTO BL_3NF.ce_sales(sale_id,cl_sale_id, sale_date, product_id, customer_id, coupon_id,
    employee_id, payment_type_id, store_id, quantity, selling_price,
    other_discount, coupon_discount, cost_price, update_dt)
        SELECT BL_3NF.sales.NEXTVAL, sss.cl_sale_id, sss.sale_date,
        CASE WHEN cp.product_id IS NULL THEN -1 ELSE cp.product_id END AS product_id,
        CASE WHEN cc.customer_id IS NULL THEN -1 ELSE  cc.customer_id END AS customer_id,
        CASE WHEN coup.coupon_id IS NULL THEN -1 ELSE coup.coupon_id END AS coupon_id,
        CASE WHEN cempl.employee_id IS NULL THEN -1 ELSE cempl.employee_id END AS employee_id,
        CASE WHEN cpt.payment_type_id IS NULL THEN -1 ELSE cpt.payment_type_id END AS payment_type_id,
        CASE WHEN ce_str.store_id IS NULL THEN -1 ELSE ce_str.store_id END AS store_id,
        sss.quantity,sss.selling_price, sss.other_discount,
        sss.coupon_discount, sss.cost_price,
        sss.update_dt
        FROM bl_cl.cl_sales sss
        LEFT JOIN BL_3NF.ce_payment_types cpt ON cpt.payment_type_natural_id = sss.payment_type_id
        LEFT JOIN BL_3NF.ce_products cp ON cp.product_natural_id = sss.item_id
        LEFT JOIN BL_3NF.ce_customers cc ON cc.customer_natural_id = sss.customer_id
        LEFT JOIN BL_3NF.ce_coupons coup ON coup.coupon_natural_id = sss.coupon_id
        LEFT JOIN BL_3NF.ce_employees cempl ON cempl.employee_natural_id = sss.employee_id
        LEFT JOIN bl_cl.store_id_temp str_tmp ON str_tmp.store_id_sales = sss.store_id
        LEFT JOIN BL_3NF.ce_stores ce_str ON ce_str.store_number = str_tmp.store_number;
        
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_sales');
    COMMIT;
    END;
     
    PROCEDURE merge_sales
    IS
    BEGIN
    
    employees_cl_to_3nf_pkg.merge_employees();
    stores_cl_to_3nf_pkg.merge_stores();
    payment_types_cl_to_3nf_pkg.merge_payment_types();
    products_cl_to_3nf_pkg.merge_products();
    customers_cl_to_3nf_pkg.merge_customers();
    coupons_cl_to_3nf_pkg.merge_coupons();
    
    merge into bl_3nf.ce_sales s
    using
    (SELECT sss.sale_date, sss.cl_sale_id, cp.product_id, cc.customer_id, coup.coupon_id,
        cempl.employee_id, cpt.payment_type_id, ce_str.store_id,
        sss.quantity,sss.selling_price, sss.other_discount,
        sss.coupon_discount, sss.cost_price, sss.update_dt
        FROM bl_cl.cl_sales sss
        JOIN BL_3NF.ce_payment_types cpt ON cpt.payment_type_natural_id = sss.payment_type_id
        JOIN BL_3NF.ce_products cp ON cp.product_natural_id = sss.item_id
        JOIN BL_3NF.ce_customers cc ON cc.customer_natural_id = sss.customer_id
        JOIN BL_3NF.ce_coupons coup ON coup.coupon_natural_id = sss.coupon_id
        JOIN BL_3NF.ce_employees cempl ON cempl.employee_natural_id = sss.employee_id
        JOIN bl_cl.store_id_temp str_tmp ON str_tmp.store_id_sales = sss.store_id
        JOIN BL_3NF.ce_stores ce_str ON ce_str.store_number = str_tmp.store_number)a
        ON (s.cl_sale_id = a.cl_sale_id)
    WHEN MATCHED THEN 
    UPDATE SET
    s.product_id = a.product_id,
    s.cost_price  = a.cost_price,
    s.selling_price = a.selling_price,
    s.quantity = a.quantity,
    s.payment_type_id = a.payment_type_id,
    s.employee_id = a.employee_id,
    s.coupon_id = a.coupon_id,
    s.customer_id = a.customer_id,
    s.update_dt = a.update_dt
    WHERE s.update_dt < a.update_dt
    WHEN NOT MATCHED THEN
    INSERT(s.sale_id,s.cl_sale_id, s.sale_date, s.product_id, s.customer_id, s.coupon_id,
    s.employee_id, s.payment_type_id, s.store_id, s.quantity, s.selling_price,
    s.other_discount, s.coupon_discount, s.cost_price, s.update_dt)
    VALUES(BL_3NF.sales.NEXTVAL, a.cl_sale_id, a.sale_date, a.product_id, a.customer_id, a.coupon_id,
    a.employee_id, a.payment_type_id, a.store_id, a.quantity, a.selling_price,
    a.other_discount, a.coupon_discount, a.cost_price, a.update_dt);
    
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_sales');
    COMMIT;
    END;
    
    
END sales_cl_to_3nf_pkg;
/