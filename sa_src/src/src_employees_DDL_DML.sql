CREATE TABLE src_employees
(
    employee_id NVARCHAR(255),
    first_name NVARCHAR(255),
    last_name NVARCHAR(255),
    email NVARCHAR(255),
    phone NVARCHAR(255),
    age NVARCHAR(255)
);


INSERT INTO src_employees (employee_id, first_name , last_name, email, phone, age)
SELECT  employee_id, first_name , last_name, email, phone, age  FROM external_employees;
COMMIT;
