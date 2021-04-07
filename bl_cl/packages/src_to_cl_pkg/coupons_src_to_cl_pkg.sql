CREATE OR REPLACE PACKAGE bl_cl.coupons_src_to_cl_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_coupons;
    --PROCEDURE merge_coupons;

END coupons_src_to_cl_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.coupons_src_to_cl_pkg
IS


    PROCEDURE insert_coupons
    IS    
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.cl_coupons';
        
    INSERT INTO cl_coupons (coupon_id,coupon_desc,issued_quantity)
    SELECT CAST(TRIM(coupon_id) as INT), TRIM(coupon_desc),
    CAST(SUBSTR(TRIM(issued_quantity),1, LENGTH(trim(issued_quantity)) -1) as INT) FROM schema_src.src_coupons;
    END;
    
   /* 
    PROCEDURE merge_coupons
    IS    
    BEGIN

    END;*/

END coupons_src_to_cl_pkg;
/