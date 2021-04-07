CREATE OR REPLACE PACKAGE bl_cl.cl_to_bl_pkg
   AUTHID DEFINER
IS
    PROCEDURE merge_coupons;
    PROCEDURE merge_employees;
    PROCEDURE merge_payment_types;
    PROCEDURE insert_stores;
    PROCEDURE insert_row_into_table(table_name IN VARCHAR2, table_columns IN VARCHAR2, table_values IN VARCHAR2);
/* TO DO
    PROCEDURE merge_sales;
    PROCEDURE merge_age_range;
    PROCEDURE merge_no_of_childs;
    PROCEDURE merge_family_sizes;
    PROCEDURE merge_customers;
    PROCEDURE merge_states;
    PROCEDURE merge_postcodes;
    PROCEDURE merge_cities;
    PROCEDURE merge_countries;
*/
END cl_to_bl_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.cl_to_bl_pkg
IS
    PROCEDURE merge_coupons
    IS    
    BEGIN
        MERGE INTO bl_3nf.ce_coupons cc
        USING (SELECT * FROM bl_cl.cl_coupons)bc ON (bc.coupon_id = cc.coupon_surrogate_id)
        WHEN MATCHED THEN  UPDATE
            SET
                cc.coupon_desc = bc.coupon_desc,
                cc.issued_quantity = bc.issued_quantity
        WHEN NOT MATCHED THEN 
        INSERT ( cc.coupon_id,  cc.coupon_surrogate_id,  cc.coupon_desc,  cc.issued_quantity)
        VALUES
        (bl_3nf.sequence_common_1.NEXTVAL, bc.coupon_id, bc.coupon_desc, bc.issued_quantity);
        COMMIT;
        log_event('Inserted or updated ' || sql%Rowcount || ' rows into table ce_coupons');
EXCEPTION 
WHEN OTHERS THEN 
  dbms_output.put_line('Error occurred.');
END;

PROCEDURE merge_employees
IS
BEGIN
 MERGE INTO bl_3nf.ce_employees ce
    USING (SELECT * FROM bl_cl.cl_employees)cl ON (ce.employee_surrogate_id = cl.employee_id)
    WHEN MATCHED THEN 
        UPDATE SET
            ce.employee_name = cl.first_name,
    ce.employee_surname = cl.last_name, 
    ce.age = cl.age, 
    ce.email = cl.email, 
    ce.phone = cl.phone 
    WHEN NOT MATCHED THEN 
    INSERT (ce.employee_id, ce.employee_surrogate_id, ce.employee_name,
 ce.employee_surname, ce.age, ce.email, ce.phone )
    VALUES
    (bl_3nf.employees.NEXTVAL, cl.employee_id, cl.first_name,
 cl.last_name, cl.age, cl.email, cl.phone);
    log_event('Inserted or updated ' || sql%Rowcount || ' rows into table ce_employees');
    COMMIT;
EXCEPTION 
WHEN OTHERS THEN 
  dbms_output.put_line('Error occurred.');
END;

PROCEDURE merge_payment_types
IS
BEGIN
 MERGE INTO bl_3nf.ce_payment_types ce
    USING (SELECT * FROM bl_cl.cl_payment_types )cl ON (ce.payment_type_surrogate_id = cl.payment_type_id)
    WHEN MATCHED THEN 
        UPDATE SET
            ce.payment_type_desc = cl.payment_type_desc
    WHEN NOT MATCHED THEN 
    INSERT (ce.payment_type_id, ce.payment_type_surrogate_id, ce.payment_type_desc)
    VALUES
    (bl_3nf.sequence_common_1.NEXTVAL, cl.payment_type_id, cl.payment_type_desc);
    log_event('Merged ' || sql%Rowcount || ' rows into table ce_payment_types');
    COMMIT;
EXCEPTION 
WHEN OTHERS THEN 
  dbms_output.put_line('Error occurred.');
END;

PROCEDURE insert_stores
IS
CURSOR cur1 IS SELECT country FROM bl_cl.cl_stores
        GROUP BY country;
country_curs bl_cl.cl_stores.country%type;
BEGIN
    OPEN cur1;
    LOOP
    FETCH cur1 INTO country_curs;
    INSERT INTO bl_3nf.ce_countries(country_id, country_name)
    SELECT bl_3nf.sequence_common_2.NEXTVAL, country_curs FROM dual;
    log_event('Inserted country ' || country_curs || ' into table ce_countries');
    IF CUR1%NOTFOUND
    THEN EXIT;
    END IF;
    END LOOP;
    
    INSERT INTO bl_3nf.ce_states(state_id, state_name, country_id)
    SELECT bl_3nf.sequence_common_2.NEXTVAL, state_province, cc.country_id FROM
        (SELECT  state_province, country FROM bl_cl.cl_stores
        GROUP BY state_province, country)a
    JOIN bl_3nf.ce_countries cc ON cc.country_name = a.country;
    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_states');
    
    INSERT INTO bl_3nf.ce_cities(city_id, city_name, state_id)
    SELECT bl_3nf.sequence_common_2.NEXTVAL, city, cs.state_id FROM
        (SELECT  city, state_province FROM bl_cl.cl_stores
        GROUP BY city, state_province)a
    JOIN bl_3nf.ce_states cs ON cs.state_name = a.state_province;
    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_cities');
    
    INSERT INTO bl_3nf.ce_postcodes( postcode_id, postcode )
    SELECT bl_3nf.sequence_common_2.NEXTVAL, postcode FROM
        (SELECT  postcode FROM bl_cl.cl_stores
        GROUP BY postcode)a;
    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_postcodes');
    
    INSERT INTO bl_3nf.ce_stores(store_id, store_number,
        store_name,street_address,
        phone_number,city_id,postcode_id)
    SELECT bl_3nf.stores.NEXTVAL, ss.store_number, ss.store_name, ss.street_address, ss.phone_number,
    ci.city_id,cp.postcode_id FROM bl_cl.cl_stores ss
    JOIN bl_3nf.ce_postcodes cp ON ss.postcode = cp.postcode
    JOIN bl_3nf.ce_cities ci ON ci.city_name = ss.city
    JOIN bl_3nf.ce_states cs ON cs.state_id = ci.state_id
    JOIN bl_3nf.ce_countries ccount ON ccount.country_id = cs.country_id
    WHERE cs.state_name = ss.state_province
    AND ccount.country_name = ss.country;
    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_stores');
    COMMIT;
EXCEPTION 
   WHEN OTHERS THEN 
      dbms_output.put_line('Error occurred.');
END;

PROCEDURE insert_row_into_table(
    table_name IN VARCHAR2,
    table_columns IN VARCHAR2,
    table_values IN VARCHAR2)
IS
    sql_statement VARCHAR2(300);
BEGIN
    sql_statement := 'INSERT INTO :1 ( :2 ) VALUES (:3 )
    RETURNING id INTO l_id;';
    EXECUTE IMMEDIATE sql_statement USING table_name, table_columns, table_values;
    COMMIT;
    log_event('Inserted ' || table_values || ' into table '||table_name);
EXCEPTION 
   WHEN OTHERS THEN 
      dbms_output.put_line('Error occurred.');
END;
END cl_to_bl_pkg;
/
