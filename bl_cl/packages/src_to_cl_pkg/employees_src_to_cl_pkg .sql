CREATE OR REPLACE PACKAGE bl_cl.employees_src_to_cl_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_employees;
    --PROCEDURE merge_employees;

END employees_src_to_cl_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.employees_src_to_cl_pkg
IS

    PROCEDURE insert_employees
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.cl_employees';
    
    INSERT INTO cl_employees (employee_id, first_name , last_name, email, phone, age)
        SELECT  CAST(employee_id AS INT), TRIM(first_name), TRIM(last_name),
    TRIM(email), TRIM(phone),CAST(SUBSTR(age, 1, 2) AS INT)  FROM schema_src.src_employees;
    log_event('Inserted ' || sql%Rowcount || ' rows into table bl_cl.cl_employees');
    COMMIT;
    
    END;
    
   /* PROCEDURE merge_employees
    IS
    BEGIN
    
    log_event('Merged ' || sql%Rowcount || ' rows into table bl_cl.cl_employees');
    COMMIT;
    END;*/
END employees_src_to_cl_pkg;
/