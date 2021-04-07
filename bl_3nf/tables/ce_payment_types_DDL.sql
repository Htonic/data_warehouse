CREATE TABLE ce_payment_types (
    payment_type_id            INTEGER PRIMARY KEY,
    payment_type_natural_id  INTEGER NOT NULL,
    payment_type_desc          VARCHAR2(20) NOT NULL,
    update_dt                  DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_payment_types(payment_type_id, payment_type_natural_id,
 payment_type_desc) VALUES
(-1, -1, 'N/A');
COMMIT;