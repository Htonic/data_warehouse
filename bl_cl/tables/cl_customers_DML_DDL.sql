CREATE TABLE cl_customers(
    customer_id INT,
    age_range NVARCHAR(8),
    marital_status NVARCHAR(40),
    rented INT,
    family_size NVARCHAR(4),
    no_of_children NVARCHAR(4),
    income_bracket INT
);


INSERT INTO cl_customers ( customer_id, age_range, family_size, income_bracket,
 marital_status,no_of_children, rented)
SELECT CAST(customer_id AS INT), trim(age_range), trim(family_size), CAST(income_bracket AS INT),
CASE WHEN marital_status IS NULL THEN NULL ELSE trim(marital_status) END AS marital_status,
CASE WHEN no_of_children IS NULL THEN NULL ELSE trim(no_of_children) END AS no_of_children,
CAST(rented AS INT) FROM schema_src.src_customers;
COMMIT;