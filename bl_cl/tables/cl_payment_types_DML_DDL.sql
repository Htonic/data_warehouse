CREATE TABLE cl_payment_types(
    payment_type_id INT,
    payment_type_desc VARCHAR2(20)
)
;

INSERT INTO cl_payment_types(payment_type_id, payment_type_desc)
SELECT CAST(payment_type_id AS INT), trim(payment_type_desc) FROM schema_src.src_payment_types;
COMMIT;