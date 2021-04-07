INSERT INTO ce_coupons(coupon_id, coupon_natural_id, coupon_desc, issued_quantity, update_dt)
SELECT sequence_common_1.NEXTVAL, coupon_id, coupon_desc, issued_quantity, current_Date 
FROM bl_cl.cl_coupons;
COMMIT;
