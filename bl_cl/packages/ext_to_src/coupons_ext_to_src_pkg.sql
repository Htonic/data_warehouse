CREATE OR REPLACE PACKAGE bl_cl.coupons_ext_to_src_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_coupons;
    PROCEDURE merge_coupons;

END coupons_ext_to_src_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.coupons_ext_to_src_pkg
IS


    PROCEDURE insert_coupons
    IS    
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE schema_src.src_coupons';
        
        INSERT INTO schema_src.src_coupons (coupon_id,coupon_desc,issued_quantity)
            SELECT coupon_id, coupon_desc, issued_quantity FROM schema_src.external_coupons;

        
        log_event('Inserted ' || sql%Rowcount || ' rows into table src_coupons');
        COMMIT;
    END;
    
    
    PROCEDURE merge_coupons
    IS    
    BEGIN
    
    INSERT INTO schema_src.src_coupons (coupon_id,coupon_desc,issued_quantity)
        SELECT coupon_id,coupon_desc,issued_quantity FROM schema_src.external_coupons
        MINUS
        SELECT coupon_id,coupon_desc,issued_quantity FROM schema_src.src_coupons;
    

    
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_coupons');
    COMMIT;
        
    END;

END coupons_ext_to_src_pkg;
/