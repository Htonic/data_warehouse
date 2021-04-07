CREATE OR REPLACE PACKAGE bl_cl.payment_types_ext_to_src_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_payment_types;
    PROCEDURE merge_payment_types;

END payment_types_ext_to_src_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.payment_types_ext_to_src_pkg
IS
    PROCEDURE insert_payment_types
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE schema_src.src_payment_types';
    
    INSERT INTO schema_src.src_payment_types(payment_type_id, payment_type_desc)
        SELECT payment_type_id, payment_type_desc FROM schema_src.external_payment_types;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_payment_types');
    COMMIT;
    
    END;
    
PROCEDURE merge_payment_types
IS
BEGIN
    INSERT INTO schema_src.src_payment_types(payment_type_id, payment_type_desc)
        SELECT payment_type_id, payment_type_desc FROM schema_src.external_payment_types
        MINUS
        SELECT payment_type_id, payment_type_desc FROM schema_src.src_payment_types;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_payment_types');
    COMMIT;
END;
    
END payment_types_ext_to_src_pkg;
/