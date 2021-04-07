CREATE OR REPLACE PACKAGE bl_cl.payment_types_cl_to_3nf_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_payment_types;
    PROCEDURE merge_payment_types;

END payment_types_cl_to_3nf_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.payment_types_cl_to_3nf_pkg
IS
    PROCEDURE insert_payment_types
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_payment_types';
    
    INSERT INTO bl_3nf.ce_payment_types(payment_type_id, payment_type_natural_id,
 payment_type_desc, update_dt) VALUES
        (-1, -1, 'N/A', current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_payment_types');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_payment_types (payment_type_id, payment_type_natural_id, payment_type_desc, update_dt)
        SELECT bl_3nf.sequence_common_1.NEXTVAL, cl.payment_type_id, cl.payment_type_desc, current_date
        FROM bl_cl.cl_payment_types cl;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_payment_types');
    COMMIT;
    
    END;
    
PROCEDURE merge_payment_types
IS
BEGIN
 MERGE INTO bl_3nf.ce_payment_types ce
    USING (SELECT * FROM bl_cl.cl_payment_types )cl ON (ce.payment_type_natural_id = cl.payment_type_id)
    WHEN MATCHED THEN 
        UPDATE SET
            ce.payment_type_desc = cl.payment_type_desc
    WHEN NOT MATCHED THEN 
    INSERT (ce.payment_type_id, ce.payment_type_natural_id, ce.payment_type_desc, ce.update_dt)
    VALUES
    (bl_3nf.sequence_common_1.NEXTVAL, cl.payment_type_id, cl.payment_type_desc, current_date);
    
    log_event('Merged ' || sql%Rowcount || ' rows into table ce_payment_types');
    COMMIT;
    
EXCEPTION 
WHEN OTHERS THEN 
  dbms_output.put_line('Error occurred.');
END;
    
END payment_types_cl_to_3nf_pkg;
/