CREATE OR REPLACE PACKAGE bl_cl.coupons_3nf_to_dm_pkg
   AUTHID DEFINER
IS
    PROCEDURE merge_coupons;
    PROCEDURE insert_coupons;
END coupons_3nf_to_dm_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.coupons_3nf_to_dm_pkg
IS
    PROCEDURE insert_coupons
    IS
    BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE BL_DM.DIM_COUPONS';
    INSERT INTO bl_dm.dim_coupons (coupon_surrogate_id, coupon_id,coupon_natural_id, coupon_desc,
        issued_quantity, update_dt)
    SELECT bl_dm.sequence_coupons.nextval, coupon_id,coupon_natural_id, coupon_desc, issued_quantity, update_dt
    FROM BL_3NF.ce_coupons;
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows updated in table bl_dm.dim_coupons');
    END;
    
    PROCEDURE merge_coupons
    IS
    BEGIN
    MERGE INTO bl_dm.dim_coupons bd
    USING (SELECT * FROM BL_3NF.ce_coupons )be ON (bd.coupon_id = be.coupon_id)
    WHEN MATCHED THEN 
        UPDATE SET
            bd.coupon_desc = be.coupon_desc,
            bd.issued_quantity = be.issued_quantity,
            bd.update_dt = be.update_dt
            WHERE bd.update_dt <> be.update_dt
    WHEN NOT MATCHED THEN 
    INSERT (bd.coupon_surrogate_id, bd.coupon_id, bd.coupon_natural_id,
        bd.coupon_desc, bd.issued_quantity)
    VALUES
    (bl_dm.SEQUENCE_PAYMENT_TYPES.nextval, be.coupon_id, be.coupon_natural_id,
    be.coupon_desc, be.issued_quantity);
    log_event('Merged ' || sql%Rowcount || ' rows into table bl_dm.dim_coupons');
    END;
END coupons_3nf_to_dm_pkg;
/
