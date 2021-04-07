INSERT INTO bl_dm.dim_coupons (coupon_id, coupon_surrogate_id, coupon_desc,
    issued_quantity)
SELECT sequence_coupons.nextval, coupon_id, coupon_desc, issued_quantity
FROM BL_3NF.ce_coupons;
COMMIT;
