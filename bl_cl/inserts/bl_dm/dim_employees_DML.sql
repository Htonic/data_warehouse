INSERT INTO bl_dm.dim_employees (employee_id, employee_surrogate_id, employee_name,
    employee_surname, age, email, phone)
SELECT sequence_employees.nextval, employee_id,  employee_name,
    employee_surname, age, email, phone
FROM BL_3NF.ce_employees;
COMMIT;
