INSERT INTO bl_dm.dim_payment_types (payment_type_id,
    payment_type_surrogate_id, payment_type_desc)
SELECT SEQUENCE_PAYMENT_TYPES.nextval, payment_type_id, payment_type_desc
FROM BL_3NF.ce_payment_types;
COMMIT;
