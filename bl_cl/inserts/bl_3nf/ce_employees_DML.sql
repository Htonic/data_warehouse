INSERT INTO ce_employees(employee_id, employee_surrogate_id, employee_name,
 employee_surname, age, email, phone)
SELECT employees.NEXTVAL, employee_id, first_name,
 last_name, age, email, phone 
FROM bl_cl.cl_employees;
COMMIT;
