CREATE OR REPLACE PACKAGE bl_cl.coupons_cl_to_3nf_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_coupons;
    PROCEDURE merge_coupons;

END coupons_cl_to_3nf_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.coupons_cl_to_3nf_pkg
IS


    PROCEDURE insert_coupons
    IS    
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_coupons';
        
        INSERT INTO bl_3nf.ce_coupons(coupon_id, coupon_natural_id, 
            coupon_desc, issued_quantity, update_dt) 
        VALUES
            (-1, -1, 'N/A', 0, current_date);
        log_event('Inserted default value -1 for table bl_3nf.ce_coupons');
        COMMIT;
    
        INSERT INTO bl_3nf.ce_coupons  (coupon_id, coupon_natural_id, coupon_desc, issued_quantity, update_dt)
        SELECT bl_3nf.sequence_common_1.NEXTVAL, coupon_id, coupon_desc, issued_quantity, current_Date 
        FROM bl_cl.cl_coupons;
        
        log_event('Inserted ' || sql%Rowcount || ' rows into table ce_coupons');
        COMMIT;
    EXCEPTION 
    WHEN OTHERS THEN 
      dbms_output.put_line('Error occurred.');
    END;
    
    
    PROCEDURE merge_coupons
    IS    
    BEGIN
        MERGE INTO bl_3nf.ce_coupons cc
        USING (SELECT * FROM bl_cl.cl_coupons)bc ON (bc.coupon_id = cc.coupon_natural_id)
        WHEN MATCHED THEN  UPDATE
            SET
                cc.coupon_desc = bc.coupon_desc,
                cc.issued_quantity = bc.issued_quantity
        WHEN NOT MATCHED THEN 
        INSERT ( cc.coupon_id,  cc.coupon_natural_id,  cc.coupon_desc,  cc.issued_quantity, cc.update_dt)
        VALUES
        (bl_3nf.sequence_common_1.NEXTVAL, bc.coupon_id, bc.coupon_desc, bc.issued_quantity, current_date);

        log_event('Merged ' || sql%Rowcount || ' rows into table ce_coupons');
        COMMIT;
    EXCEPTION 
    WHEN OTHERS THEN 
      dbms_output.put_line('Error occurred.');
    END;

END coupons_cl_to_3nf_pkg;
/