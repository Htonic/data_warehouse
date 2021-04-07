CREATE TABLE ce_payment_types (
    payment_type_id            INTEGER NOT NULL,
    payment_type_natural_id  INTEGER NOT NULL,
    payment_type_desc          NVARCHAR(20) NOT NULL,
    update_dt                  DATE DEFAULT GETDATE() NOT NULL
);

INSERT INTO ce_payment_types(payment_type_id, payment_type_natural_id,
 payment_type_desc) VALUES
(-1, -1, 'N/A');
COMMIT;