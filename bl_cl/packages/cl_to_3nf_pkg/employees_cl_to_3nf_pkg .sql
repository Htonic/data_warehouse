CREATE OR REPLACE PACKAGE bl_cl.employees_cl_to_3nf_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_employees;
    PROCEDURE merge_employees;

END employees_cl_to_3nf_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.employees_cl_to_3nf_pkg
IS

    PROCEDURE insert_employees
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_employees';
    
    INSERT INTO bl_3nf.ce_employees(employee_id, employee_natural_id, employee_name,
 employee_surname, age, email, phone, update_dt) VALUES 
         (-1, -1, 'N/A',
         'N/A', 0, 'N/A', 'N/A', current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_employees');
    COMMIT;
    
    INSERT INTO BL_3NF.ce_employees(employee_id, employee_natural_id, employee_name,
    employee_surname, age, email, phone, update_dt)
    SELECT BL_3NF.employees.NEXTVAL, employee_id, first_name,
    last_name, age, email, phone, current_date
    FROM bl_cl.cl_employees;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_employees');
    COMMIT;
    
    END;
    
    PROCEDURE merge_employees
    IS
    BEGIN
    
    MERGE INTO BL_3NF.ce_employees e
    USING (SELECT employee_id, first_name,
        last_name, age, email, phone 
        FROM bl_cl.cl_employees)a
    ON (a.employee_id = e.employee_natural_id)
    WHEN MATCHED THEN
    UPDATE SET
        e.employee_name = a.first_name,
        e.employee_surname = a.last_name,
        e.age = a.age,
        e.email = a.email,
        e.phone = a.phone,
        e.update_dt = current_date
    WHEN NOT MATCHED THEN
    INSERT(e.employee_id, e.employee_natural_id, e.employee_name,
    e.employee_surname, e.age, e.email, e.phone, e.update_dt)
    VALUES(bl_3nf.products.NEXTVAL, a.employee_id, a.first_name,
    a.last_name, a.age, a.email, a.phone, CURRENT_DATE);
    
    log_event('Merged ' || sql%Rowcount || ' rows into table ce_employees');
    COMMIT;
    END;
END employees_cl_to_3nf_pkg;
/