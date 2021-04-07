CREATE TABLE src_payment_types(
    payment_type_id VARCHAR2(255),
    payment_type_desc VARCHAR2(255)
)
;

INSERT INTO src_payment_types(payment_type_id, payment_type_desc)
SELECT payment_type_id, payment_type_desc FROM external_payment_types;
COMMIT;
