CREATE OR REPLACE PACKAGE bl_cl.employees_3nf_to_dm_pkg
   AUTHID DEFINER
IS
    PROCEDURE merge_employees;
    PROCEDURE insert_employees;
END employees_3nf_to_dm_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.employees_3nf_to_dm_pkg
IS
    PROCEDURE insert_employees
    IS
    BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE BL_DM.DIM_EMPLOYEES ';
    INSERT INTO bl_dm.dim_employees (employee_surrogate_id, employee_id,employee_natural_id,
    employee_name,
    employee_surname, age, email, phone, update_dt)
    SELECT bl_dm.sequence_employees.nextval, employee_id,employee_natural_id,  employee_name,
    employee_surname, age, email, phone, update_dt
    FROM BL_3NF.ce_employees;

    log_event('Inserted ' || sql%Rowcount || ' rows into table dim_employees');

    END;
    
    PROCEDURE merge_employees
        IS
    BEGIN
    MERGE INTO bl_dm.dim_employees be
    USING (SELECT * FROM BL_3NF.ce_employees)bc ON (bc.employee_id = be.employee_id)
    WHEN MATCHED THEN
        UPDATE SET 
        be.employee_surname = bc.employee_surname, 
        be.age = bc.age, 
        be.email = bc.email, 
        be.phone = bc.phone,
        be.update_dt = bc.update_dt
        WHERE be.update_dt <> bc.update_dt
    WHEN NOT MATCHED THEN
    INSERT (be.employee_surrogate_id, be.employee_id,employee_natural_id, be.employee_name,
    be.employee_surname, be.age, be.email, be.phone, be.update_dt) VALUES
    (bl_dm.sequence_employees.nextval, bc.employee_id, bc.employee_natural_id,  bc.employee_name,
    bc.employee_surname, bc.age, bc.email, bc.phone, bc.update_dt);
	
    log_event('Merged ' || sql%Rowcount || ' rows into table dim_employees');
	
    END;
END employees_3nf_to_dm_pkg;
/