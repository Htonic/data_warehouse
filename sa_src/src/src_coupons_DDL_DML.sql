CREATE TABLE src_coupons(
    coupon_id VARCHAR(255),
    coupon_desc VARCHAR(255),
    issued_quantity VARCHAR(255)
);

INSERT INTO src_coupons (coupon_id,coupon_desc,issued_quantity)
SELECT coupon_id, coupon_desc, issued_quantity FROM external_coupons;
COMMIT;