INSERT INTO ce_payment_types(payment_type_id, payment_type_surrogate_id, payment_type_desc)
SELECT sequence_common_1.NEXTVAL, payment_type_id, payment_type_desc FROM
bl_cl.cl_payment_types;
COMMIT;
