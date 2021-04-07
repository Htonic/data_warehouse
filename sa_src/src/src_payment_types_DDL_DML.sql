CREATE TABLE src_payment_types(
    payment_type_id NVARCHAR(255),
    payment_type_desc NVARCHAR(255)
)
;

INSERT INTO src_payment_types(payment_type_id, payment_type_desc)
SELECT payment_type_id, payment_type_desc FROM external_payment_types;
COMMIT;
