CREATE TABLE cl_coupons(
    coupon_id INT,
    coupon_desc NVARCHAR(60),
    issued_quantity INT
);

INSERT INTO cl_coupons (coupon_id,coupon_desc,issued_quantity)
SELECT CAST(TRIM(coupon_id) as INT), TRIM(coupon_desc),
CAST(SUBSTR(TRIM(issued_quantity),1, LENGTH(trim(issued_quantity)) -1) as INT) FROM schema_src.src_coupons;
COMMIT;