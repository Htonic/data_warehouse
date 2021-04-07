CREATE OR REPLACE PACKAGE bl_cl.customers_src_to_cl_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_customers;
    --PROCEDURE merge_customers;


END customers_src_to_cl_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.customers_src_to_cl_pkg
IS

    PROCEDURE insert_customers
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.cl_customers';


    INSERT INTO cl_customers ( customer_id, age_range, family_size, income_bracket,
    marital_status,no_of_children, rented)
    SELECT CAST(customer_id AS INT), trim(age_range), trim(family_size), CAST(income_bracket AS INT),
    CASE WHEN marital_status IS NULL THEN NULL ELSE trim(marital_status) END AS marital_status,
    CASE WHEN no_of_children IS NULL THEN NULL ELSE trim(no_of_children) END AS no_of_children,
    CAST(rented AS INT) FROM schema_src.src_customers;

    END;
  
  
   /* PROCEDURE merge_customers
    IS
    BEGIN
    
    END;*/
    

END customers_src_to_cl_pkg;
/