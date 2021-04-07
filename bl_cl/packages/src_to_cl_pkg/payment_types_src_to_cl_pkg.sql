CREATE OR REPLACE PACKAGE bl_cl.payment_types_src_to_cl_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_payment_types;
 --  PROCEDURE merge_payment_types;

END payment_types_src_to_cl_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.payment_types_src_to_cl_pkg
IS
    PROCEDURE insert_payment_types
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.cl_payment_types';
    
    INSERT INTO cl_payment_types(payment_type_id, payment_type_desc)
    SELECT CAST(payment_type_id AS INT), trim(payment_type_desc) FROM schema_src.src_payment_types;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table bl_cl.cl_payment_types');
    COMMIT;
    
    END;
    /*
PROCEDURE merge_payment_types
IS
BEGIN

END;
   */ 
END payment_types_src_to_cl_pkg;
/