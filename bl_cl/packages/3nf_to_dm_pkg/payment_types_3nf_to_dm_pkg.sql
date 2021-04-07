CREATE OR REPLACE PACKAGE bl_cl.payment_types_3nf_to_dm_pkg
   AUTHID DEFINER
IS
    PROCEDURE merge_payment_types;
    PROCEDURE insert_payment_types;
END payment_types_3nf_to_dm_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.payment_types_3nf_to_dm_pkg
IS
    PROCEDURE insert_payment_types
    IS
    BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE BL_DM.DIM_PAYMENT_TYPES';
    INSERT INTO bl_dm.dim_payment_types (payment_type_surrogate_id, payment_type_id,payment_type_natural_id
    , payment_type_desc, update_dt)
    SELECT bl_dm.SEQUENCE_PAYMENT_TYPES.nextval, payment_type_id,payment_type_natural_id, payment_type_desc, update_dt
    FROM BL_3NF.ce_payment_types;
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows updated into table bl_dm.dim_payment_types');
    END;
    
    PROCEDURE merge_payment_types
    IS
    BEGIN
     MERGE INTO bl_dm.dim_payment_types bd
    USING (SELECT * FROM BL_3NF.ce_payment_types )be ON (bd.payment_type_id = be.payment_type_id)
    WHEN MATCHED THEN 
        UPDATE SET
            bd.payment_type_desc = be.payment_type_desc,
            bd.update_dt = be.update_dt
        WHERE bd.update_dt <> be.update_dt
    WHEN NOT MATCHED THEN 
    INSERT (bd.payment_type_surrogate_id, bd.payment_type_id,bd.payment_type_natural_id,
    bd.payment_type_desc, bd.update_dt)
    VALUES
    (bl_dm.SEQUENCE_PAYMENT_TYPES.nextval, be.payment_type_id,be.payment_type_natural_id, 
        be.payment_type_desc, be.update_dt);
    log_event('Merged ' || sql%Rowcount || ' rows into table bl_dm.dim_payment_types');
    END;
END payment_types_3nf_to_dm_pkg;
/