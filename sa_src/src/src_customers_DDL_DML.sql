CREATE TABLE src_customers(
    customer_id VARCHAR(255),
    age_range NVARCHAR(255),
    marital_status VARCHAR(255),
    rented VARCHAR(255),
    family_size NVARCHAR(255),
    no_of_children NVARCHAR(255),
    income_bracket VARCHAR(255)
);


INSERT INTO src_customers ( customer_id, age_range, family_size, income_bracket,
 marital_status,no_of_children, rented)
SELECT customer_id, age_range, family_size, income_bracket,
 marital_status,no_of_children, rented FROM external_customer_demographics;
 COMMIT;