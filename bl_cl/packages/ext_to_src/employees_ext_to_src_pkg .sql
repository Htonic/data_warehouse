CREATE OR REPLACE PACKAGE bl_cl.employees_ext_to_src_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_employees;
    PROCEDURE merge_employees;

END employees_ext_to_src_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.employees_ext_to_src_pkg
IS

    PROCEDURE insert_employees
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE schema_src.src_employees';
    
    INSERT INTO schema_src.src_employees (employee_id, first_name , last_name, email, phone, age)
    SELECT  employee_id, first_name , last_name, email, phone, age  FROM schema_src.external_employees;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_employees');
    COMMIT;
    
    END;
    
    PROCEDURE merge_employees
    IS
    BEGIN
    
    INSERT INTO schema_src.src_employees (employee_id, first_name , last_name, email, phone, age)
    
    SELECT  employee_id, first_name , last_name, email, phone, age  FROM schema_src.external_employees
    MINUS
    SELECT  employee_id, first_name , last_name, email, phone, age  FROM schema_src.src_employees;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_employees');
    COMMIT;
    END;
END employees_ext_to_src_pkg;
/