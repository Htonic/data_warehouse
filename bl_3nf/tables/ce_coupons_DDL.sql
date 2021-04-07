CREATE TABLE ce_coupons(
    coupon_id            INTEGER PRIMARY KEY,
    coupon_natural_id   INTEGER NOT NULL,
    coupon_desc          VARCHAR2(60) NOT NULL,
    issued_quantity   INTEGER NOT NULL,
    update_dt            DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_coupons(coupon_id, coupon_natural_id, 
	coupon_desc, issued_quantity) VALUES
(-1, -1, 'N/A', 0);
COMMIT;