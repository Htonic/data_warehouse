CREATE OR REPLACE PACKAGE bl_cl.sa_key_represenation_pkg
   AUTHID DEFINER
IS
    PROCEDURE check_sa_key_coupons;
    PROCEDURE check_sa_key_stores;
    PROCEDURE check_sa_key_payment_types;
    PROCEDURE check_sa_key_products;
    PROCEDURE check_sa_key_customer;
    PROCEDURE check_sa_key_employees;
    PROCEDURE check_all_dimensions;
END sa_key_represenation_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.sa_key_represenation_pkg
IS
    PROCEDURE check_sa_key_coupons
    IS
    missed_keys INT := 0;
    is_passed CHAR(1) := 'Y';
    BEGIN
        SELECT COUNT(sr_id) INTO missed_keys FROM (
            SELECT src.coupon_id as sr_id, dim.coupon_natural_id FROM SCHEMA_SRC.src_coupons src
            LEFT JOIN BL_DM.dim_coupons dim ON dim.coupon_natural_id = CAST(trim(src.coupon_id) AS INT))a
        WHERE coupon_natural_id IS NULL;
        IF missed_keys <> 0 THEN
            is_passed := 'N';
        END IF;
        
        INSERT INTO bl_cl.test_report_table(  
            user_session, test_name, test_description,
            test_passed, test_date) 
        VALUES (user, 'representation check', 'Table dim_coupons has been checked for representation of all src natural keys'||
        ' and were found ' || missed_keys || ' missed keys'
        , is_passed, CURRENT_TIMESTAMP);
        COMMIT;
    END;
    
    PROCEDURE check_sa_key_stores
    IS
    missed_keys INT := 0;
    is_passed CHAR(1) := 'Y';
    BEGIN
        SELECT COUNT(sr_id) INTO missed_keys FROM (
            SELECT src.store_number as sr_id, dim.store_number FROM SCHEMA_SRC.src_stores src
            LEFT JOIN BL_DM.dim_stores dim ON dim.store_number = trim(src.store_number))a
        WHERE store_number IS NULL;
        IF missed_keys <> 0 THEN
            is_passed := 'N';
        END IF;
        
        INSERT INTO bl_cl.test_report_table(  
            user_session, test_name, test_description,
            test_passed, test_date) 
        VALUES (user, 'representation check', 'Table dim_stores has been checked for representation of all src natural keys'||
        ' and were found ' || missed_keys || ' missed keys'
        , is_passed, CURRENT_TIMESTAMP);
        COMMIT;
    END;
    
    PROCEDURE check_sa_key_payment_types
    IS
    missed_keys INT := 0;
    is_passed CHAR(1) := 'Y';
    BEGIN
        SELECT COUNT(sr_id) INTO missed_keys FROM (
            SELECT src.payment_type_id as sr_id, dim.payment_type_natural_id FROM SCHEMA_SRC.src_payment_types src
            LEFT JOIN BL_DM.dim_payment_types dim ON dim.payment_type_natural_id = CAST(trim(src.payment_type_id) AS INT))a
        WHERE payment_type_natural_id IS NULL;
        IF missed_keys <> 0 THEN
            is_passed := 'N';
        END IF;
        
        INSERT INTO bl_cl.test_report_table(  
            user_session, test_name, test_description,
            test_passed, test_date) 
        VALUES (user, 'representation check', 'Table dim_payment_types has been checked for representation of all src natural keys'||
        ' and were found ' || missed_keys || ' missed keys'
        , is_passed, CURRENT_TIMESTAMP);
        COMMIT;
    END;
    
    PROCEDURE check_sa_key_products
    IS
    missed_keys INT := 0;
    is_passed CHAR(1) := 'Y';
    BEGIN
        SELECT COUNT(sr_id) INTO missed_keys FROM (
            SELECT src.item_id as sr_id,dim.product_natural_id  FROM SCHEMA_SRC.src_products src
            LEFT JOIN BL_DM.dim_products dim ON dim.product_natural_id =  CAST(trim(src.item_id) AS INT))a
        WHERE product_natural_id IS NULL;
        IF missed_keys <> 0 THEN
            is_passed := 'N';
        END IF;
        
        INSERT INTO bl_cl.test_report_table(  
            user_session, test_name, test_description,
            test_passed, test_date) 
        VALUES (user, 'representation check', 'Table dim_products has been checked for representation of all src natural keys'||
        ' and were found ' || missed_keys || ' missed keys'
        , is_passed, CURRENT_TIMESTAMP);
        COMMIT;
    END;
    
    PROCEDURE check_sa_key_customer
    IS
    missed_keys INT := 0;
    is_passed CHAR(1) := 'Y';
    BEGIN
        SELECT COUNT(sr_id) INTO missed_keys FROM (
            SELECT src.customer_id as sr_id, dim.customer_natural_id FROM SCHEMA_SRC.src_customers src
            LEFT JOIN BL_DM.dim_customers dim ON dim.customer_natural_id = CAST(trim(src.customer_id) AS INT))a
        WHERE customer_natural_id IS NULL;
        IF missed_keys <> 0 THEN
            is_passed := 'N';
        END IF;
        
        INSERT INTO bl_cl.test_report_table(  
            user_session, test_name, test_description,
            test_passed, test_date) 
        VALUES (user, 'representation check', 'Table dim_customers has been checked for representation of all src natural keys'||
        ' and were found ' || missed_keys || ' missed keys'
        , is_passed, CURRENT_TIMESTAMP);
        COMMIT;
    END;
    
    PROCEDURE check_sa_key_employees
    IS
    missed_keys INT := 0;
    is_passed CHAR(1) := 'Y';
    BEGIN
        SELECT COUNT(sr_id) INTO missed_keys FROM (
            SELECT src.employee_id as sr_id, dim.employee_natural_id FROM SCHEMA_SRC.src_employees src
            LEFT JOIN BL_DM.dim_employees dim ON dim.employee_natural_id = CAST(trim(src.employee_id) AS INT))a
        WHERE employee_natural_id IS NULL;
        IF missed_keys <> 0 THEN
            is_passed := 'N';
        END IF;
        
        INSERT INTO bl_cl.test_report_table(  
            user_session, test_name, test_description,
            test_passed, test_date) 
        VALUES (user, 'representation check', 'Table dim_employees has been checked for representation of all src natural keys'||
        ' and were found ' || missed_keys || ' missed keys'
        , is_passed, CURRENT_TIMESTAMP);
        COMMIT;
    END;
    
     PROCEDURE check_all_dimensions
     IS
     BEGIN
         check_sa_key_coupons;
         check_sa_key_stores;
         check_sa_key_payment_types;
         check_sa_key_products;
         check_sa_key_customer;
         check_sa_key_employees;
     END;
END sa_key_represenation_pkg;