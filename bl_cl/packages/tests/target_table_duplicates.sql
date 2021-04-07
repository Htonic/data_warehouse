CREATE OR REPLACE PACKAGE bl_cl.target_table_duplicates
   AUTHID DEFINER
IS
    PROCEDURE check_duplicates(table_name IN VARCHAR2,table_columns IN VARCHAR2);
    PROCEDURE check_dm_coupons;
    PROCEDURE check_dm_stores;
    PROCEDURE check_dm_payment_types;
    PROCEDURE check_dm_products;
    PROCEDURE check_dm_customer;
    PROCEDURE check_dm_employees;
    PROCEDURE check_all_dimensions;
END target_table_duplicates;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.target_table_duplicates
IS
    PROCEDURE check_duplicates(table_name IN VARCHAR2,table_columns IN VARCHAR2 ) 
    IS
    duplicate_number INTEGER;
    is_passed CHAR(1) := 'Y';
    sql_query VARCHAR2(6000);
    BEGIN
        sql_query := trim('SELECT COUNT(*) FROM ( 
            SELECT COUNT(*) FROM '|| table_name ||'
            GROUP BY  '|| table_columns ||'  HAVING COUNT(*) > 1)a');

        EXECUTE IMMEDIATE sql_query into duplicate_number;
        
        IF duplicate_number <> 0 THEN
            is_passed := 'N';
        END IF;
        
        INSERT INTO bl_cl.test_report_table(  
            user_session, test_name, test_description,
            test_passed, test_date) 
        VALUES (user, 'duplicate check', 'Table ' || table_name || ' has been checked for duplicates'||
        ' and were found ' || duplicate_number || ' duplicates'
        , is_passed, CURRENT_TIMESTAMP);
        COMMIT;
    END;
    
    PROCEDURE check_dm_coupons
    IS
    BEGIN
        check_duplicates('BL_DM.dim_coupons', ' coupon_id, coupon_natural_id,
        coupon_desc, issued_quantity ');
    END;
    
    PROCEDURE check_dm_employees
    IS
    BEGIN
        check_duplicates('BL_DM.dim_employees', ' employee_id, employee_natural_id, employee_name,
        employee_surname, age, email, phone ');
    END;
    
    PROCEDURE check_dm_stores
    IS
    BEGIN
        check_duplicates('BL_DM.dim_stores', ' store_id, store_number, store_name, street_address, city_name, 
        state_or_province, country_name, postcode, phone_number, city_id, state_id, country_id, postcode_id ');
    END;
    PROCEDURE check_dm_payment_types
    IS
    BEGIN
        check_duplicates('BL_DM.dim_payment_types' , ' payment_type_id,
        payment_type_natural_id, payment_type_desc ');
    END;
    
    PROCEDURE check_dm_products
    IS
    BEGIN
         check_duplicates('BL_DM.dim_products' ,
           'product_id,
            product_natural_id ,
            brand,
            brand_type,
            brand_id,
            brand_type_id,
            product_category_desc,
            product_category_id,
            start_date,
            end_date,
            is_active ');
    END;
    
    PROCEDURE check_dm_customer
    IS
    BEGIN
        check_duplicates('BL_DM.dim_customers', ' customer_id, customer_natural_id,
        age_range, marital_status, rented, family_size, no_of_child, income_bracket,
        age_range_id, no_of_child_id, family_size_id, marital_status_id ');
    END;
    
    PROCEDURE check_all_dimensions
    IS
    BEGIN
    check_dm_coupons;
    check_dm_stores;
    check_dm_payment_types;
    check_dm_products;
    check_dm_customer;
    END;
END target_table_duplicates;
    
    