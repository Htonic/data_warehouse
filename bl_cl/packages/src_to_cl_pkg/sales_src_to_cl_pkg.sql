CREATE OR REPLACE PACKAGE bl_cl.sales_src_to_cl_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_sales;
    PROCEDURE merge_sales;

END sales_src_to_cl_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.sales_src_to_cl_pkg
IS
    PROCEDURE insert_sales
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.cl_sales';
    
    
    INSERT INTO cl_sales (cl_sale_id, coupon_id, store_id, payment_type_id, employee_id,
      sale_date, customer_id, item_id, quantity,
      selling_price, cost_price, other_discount, coupon_discount,update_dt)
    SELECT BL_CL.cl_sale_seq.NEXTVAL ,CAST(coupon_id AS INT), CAST(store_id AS INT),
    CAST(payment_type_id AS INT) ,CAST(employee_id AS INT),
      TO_DATE(TRIM(sale_date), 'YYYY-MM-DD'),CAST(customer_id AS INT), CAST(item_id AS INT), CAST(quantity AS INT),
      TO_NUMBER(TRIM(selling_price), '9999999.99'), TO_NUMBER(TRIM(selling_price), '9999999.99') * 0.75,
      TO_NUMBER(TRIM(other_discount), '9999999.99'), 
      TO_NUMBER(substr(trim(coupon_discount), 1, LENGTH(trim(coupon_discount)) -1), '99999999.99'),
      current_Date
    FROM schema_src.src_sales;
    
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_cl.cl_sales');
    COMMIT;
    END;
     
    PROCEDURE merge_sales
    IS
    BEGIN

     INSERT INTO cl_sales (cl_sale_id, coupon_id, store_id, payment_type_id, employee_id,
      sale_date, customer_id, item_id, quantity,
      selling_price, cost_price, other_discount, coupon_discount,update_dt)
    SELECT BL_CL.cl_sale_seq.NEXTVAL, coupon_id, store_id, payment_type_id, employee_id,
          sale_date, customer_id, item_id, quantity,
          selling_price, cost_price, other_discount, coupon_discount, current_Date FROM 
          (
            SELECT CAST(coupon_id AS INT) as coupon_id, CAST(store_id AS INT) as store_id,
            CAST(payment_type_id AS INT) as payment_type_id,CAST(employee_id AS INT) as employee_id,
              TO_DATE(TRIM(sale_date) , 'YYYY-MM-DD') as sale_date,CAST(customer_id AS INT) as customer_id,
              CAST(item_id AS INT) as item_id, CAST(quantity AS INT) as quantity,
              TO_NUMBER(TRIM(selling_price), '9999999.99') as selling_price,
              TO_NUMBER(TRIM(selling_price), '9999999.99') * 0.75 as cost_price,
              TO_NUMBER(TRIM(other_discount), '9999999.99') as other_discount, 
              TO_NUMBER(substr(trim(coupon_discount), 1, LENGTH(trim(coupon_discount)) -1), '99999999.99') as coupon_discount
              FROM schema_src.src_sales
            MINUS
                SELECT coupon_id, store_id, payment_type_id, employee_id,
              sale_date, customer_id, item_id, quantity,
              selling_price, cost_price, other_discount, coupon_discount FROM cl_sales
          );
    
    
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_cl.cl_sales');
    COMMIT;
    END;
    
    
END sales_src_to_cl_pkg;
/