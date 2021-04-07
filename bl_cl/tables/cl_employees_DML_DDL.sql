CREATE TABLE cl_employees
(
    employee_id INT,
    first_name NVARCHAR(80),
    last_name NVARCHAR(80),
    email NVARCHAR(80),
    phone NVARCHAR(80),
    age INT
);


INSERT INTO cl_employees (employee_id, first_name , last_name, email, phone, age)
SELECT  CAST(employee_id AS INT), TRIM(first_name), TRIM(last_name),
    TRIM(email), TRIM(phone),CAST(SUBSTR(age, 1, 2) AS INT)  FROM schema_src.src_employees;
COMMIT;