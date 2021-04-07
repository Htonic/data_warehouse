CREATE OR REPLACE PACKAGE bl_cl.customers_ext_to_src_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_customers;
    PROCEDURE merge_customers;


END customers_ext_to_src_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.customers_ext_to_src_pkg
IS

    PROCEDURE insert_customers
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE schema_src.src_customers';
    
    INSERT INTO schema_src.src_customers ( customer_id, age_range, family_size, income_bracket,
     marital_status,no_of_children, rented)
    SELECT customer_id, age_range, family_size, income_bracket,
     marital_status,no_of_children, rented FROM schema_src.external_customer_demographics;
     
     log_event('Inserted ' || sql%Rowcount || ' rows into table src_customers');
     COMMIT;
 
    END;
    
    PROCEDURE merge_customers
    IS
    BEGIN
    
    INSERT INTO schema_src.src_customers ( customer_id, age_range, family_size, income_bracket,
     marital_status,no_of_children, rented)
    SELECT customer_id, age_range, family_size, income_bracket,
     marital_status,no_of_children, rented FROM schema_src.external_customer_demographics
     MINUS 
     SELECT customer_id, age_range, family_size, income_bracket,
     marital_status,no_of_children, rented FROM schema_src.src_customers;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_customers');
     COMMIT;
    END;
END customers_ext_to_src_pkg;
/