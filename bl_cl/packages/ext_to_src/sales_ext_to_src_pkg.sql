CREATE OR REPLACE PACKAGE bl_cl.sales_ext_to_src_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_sales;

END sales_ext_to_src_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.sales_ext_to_src_pkg
IS
    PROCEDURE insert_sales
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE schema_src.src_sales';
    
    INSERT INTO schema_src.src_sales ( coupon_id, store_id, payment_type_id, employee_id,
    sale_date, customer_id, item_id, quantity,
    selling_price, other_discount, coupon_discount)
    SELECT coupon_id, store_id, payment_type_id, employee_id,
    "date", customer_id, item_id, quantity,selling_price, other_discount, coupon_discount
    FROM schema_src.external_customer_transaction;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_sales');
    COMMIT;
    END;    
    
END sales_ext_to_src_pkg;
/