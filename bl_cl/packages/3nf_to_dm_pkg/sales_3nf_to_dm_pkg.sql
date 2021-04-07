CREATE OR REPLACE PACKAGE bl_cl.sales_3nf_to_dm_pkg
   AUTHID DEFINER
IS
    PROCEDURE sales_initial_load;
    PROCEDURE create_partition(sale_date IN DATE);
	PROCEDURE sales_incremental_load_last_month;
  
END sales_3nf_to_dm_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.sales_3nf_to_dm_pkg
IS

    PROCEDURE create_partition(sale_date IN DATE)
    IS
    first_day_next_month VARCHAR2(10);
    year_month VARCHAR2(7);
    sttmn VARCHAR2(400);
    BEGIN
    first_day_next_month := TO_CHAR(trunc(add_months(sale_date, 1),'mon'), 'dd.mm.yyyy');
    year_month := SUBSTR(TO_CHAR(LAST_DAY(sale_date), 'yyyy_mm_dd'), 1, 7);
    sttmn := TRIM('ALTER TABLE bl_dm.fct_sales ADD PARTITION part_' || year_month || ' VALUES' ||
    ' LESS THAN (''' || first_day_next_month || ''')');
    EXECUTE IMMEDIATE sttmn;
    log_event('Created partition part_' || year_month || ' for table bl_dm.fct_sales');
    END;

    PROCEDURE sales_initial_load
    IS
    min_date DATE;
    max_date DATE;
    curr_date DATE;
    BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.fct_sales';
    bl_dm.work_with_partition.drop_all_partitions;
      
    SELECT MAX(c.sale_date) INTO max_date FROM BL_3NF.ce_sales c;
    SELECT MIN(c.sale_date) INTO min_date FROM BL_3NF.ce_sales c;
    curr_date := min_date;
    LOOP
    EXIT WHEN curr_date > max_date;
    create_partition(curr_date);
    curr_date := add_months(curr_date, 1);
    END LOOP;
    
	INSERT INTO bl_dm.fct_sales (sale_id, product_surrogate_id, customer_surrogate_id,
    sale_date, coupon_surrogate_id, employee_surrogate_id, payment_type_surrogate_id, store_surrogate_id,
    quantity, selling_price, cost_price, other_discount, coupon_discount, update_dt)
	
	SELECT bl_dm.sequence_sales.nextval, prod.product_surrogate_id, cust.customer_surrogate_id,
	cs.sale_date, coup.coupon_surrogate_id, empl.employee_surrogate_id, paym.payment_type_surrogate_id,
	stor.store_surrogate_id, cs.quantity, cs.selling_price, cs.cost_price,
	cs.other_discount, cs.coupon_discount, cs.update_dt
	FROM BL_3NF.ce_sales cs 
	JOIN bl_dm.dim_coupons coup ON coup.coupon_id = cs.coupon_id 
	JOIN bl_dm.dim_customers cust ON cust.customer_id = cs.customer_id
	JOIN bl_dm.dim_employees empl ON empl.employee_id = cs.employee_id
	JOIN bl_dm.dim_products prod ON prod.product_id = cs.product_id
	JOIN bl_dm.dim_stores stor ON stor.store_id = cs.store_id
	JOIN bl_dm.dim_payment_types paym ON paym.payment_type_id = cs.payment_type_id;
	
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows  into table bl_dm.fct_sales');
    COMMIT;
    END;
    
    PROCEDURE sales_incremental_load_last_month
    IS
    part_name VARCHAR2(12);
    sttm VARCHAR(300);
    is_exist NUMBER := 0;
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE tmp_fct_sales';
    
    INSERT INTO bl_dm.tmp_fct_sales (sale_id, product_surrogate_id, customer_surrogate_id,
    sale_date, coupon_surrogate_id, employee_surrogate_id, payment_type_surrogate_id, store_surrogate_id,
    quantity, selling_price, cost_price, other_discount, coupon_discount, update_dt)
	
	SELECT bl_dm.sequence_sales.NEXTVAL, prod.product_surrogate_id, cust.customer_surrogate_id,
	cs.sale_date, coup.coupon_surrogate_id, empl.employee_surrogate_id, paym.payment_type_surrogate_id,
	stor.store_surrogate_id, cs.quantity, cs.selling_price, cs.cost_price,
	cs.other_discount, cs.coupon_discount, cs.update_dt
	FROM bl_3nf.ce_sales cs 
	JOIN bl_dm.dim_coupons coup ON coup.coupon_id = cs.coupon_id 
	JOIN bl_dm.dim_customers cust ON cust.customer_id = cs.customer_id
	JOIN bl_dm.dim_employees empl ON empl.employee_id = cs.employee_id
	JOIN bl_dm.dim_products prod ON prod.product_id = cs.product_id
	JOIN bl_dm.dim_stores stor ON stor.store_id = cs.store_id
	JOIN bl_dm.dim_payment_types paym ON paym.payment_type_id = cs.payment_type_id
    WHERE  EXTRACT(MONTH FROM sysdate) = EXTRACT(MONTH FROM cs.sale_date)
    AND EXTRACT(YEAR FROM sysdate) = EXTRACT(YEAR FROM cs.sale_date);
    COMMIT;
	
    part_name := 'part_' || substr(to_char(last_day(sysdate), 'yyyy_mm_dd'), 1, 7);
    SELECT COUNT(*)
      INTO is_exist
      FROM all_tab_partitions
      WHERE table_name   = 'FCT_SALES'
      AND table_owner = 'BL_DM'
      AND partition_name = UPPER(part_name);
    IF is_exist = 0 THEN
        create_partition(sysdate);
    END IF;
    
    sttm := TRIM('ALTER TABLE bl_dm.fct_sales 
        EXCHANGE PARTITION ' || part_name || '
          WITH TABLE bl_cl.tmp_fct_sales');
    EXECUTE IMMEDIATE sttm;
    log_event('Exchanged partition ' || part_name || ' for table bl_dm.fct_sales');
    END;
END sales_3nf_to_dm_pkg;
/