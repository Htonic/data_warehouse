CREATE TABLE cl_employees
(
    employee_id INT,
    first_name VARCHAR2(80),
    last_name VARCHAR2(80),
    email VARCHAR2(80),
    phone VARCHAR2(80),
    age INT
);


INSERT INTO cl_employees (employee_id, first_name , last_name, email, phone, age)
SELECT  CAST(employee_id AS INT), TRIM(first_name), TRIM(last_name),
    TRIM(email), TRIM(phone),CAST(SUBSTR(age, 1, 2) AS INT)  FROM schema_src.src_employees;
COMMIT;