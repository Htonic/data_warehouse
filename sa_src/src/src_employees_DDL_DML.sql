CREATE TABLE src_employees
(
    employee_id VARCHAR2(255),
    first_name VARCHAR2(255),
    last_name VARCHAR2(255),
    email VARCHAR2(255),
    phone VARCHAR2(255),
    age VARCHAR2(255)
);


INSERT INTO src_employees (employee_id, first_name , last_name, email, phone, age)
SELECT  employee_id, first_name , last_name, email, phone, age  FROM external_employees;
COMMIT;
