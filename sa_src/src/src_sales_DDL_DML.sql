CREATE TABLE src_sales(
  coupon_id  VARCHAR2(255),
  store_id  VARCHAR2(255),
  payment_type_id  VARCHAR2(255),
  employee_id  VARCHAR2(255),
  sale_date VARCHAR2(255),
  customer_id  VARCHAR2(255),
  item_id VARCHAR2(255),
  quantity VARCHAR2(255),
  selling_price VARCHAR2(255),
  other_discount VARCHAR2(255),
  coupon_discount VARCHAR2(255)
);

INSERT INTO src_sales ( coupon_id, store_id, payment_type_id, employee_id,
  sale_date, customer_id, item_id, quantity,
  selling_price, other_discount, coupon_discount)
SELECT coupon_id, store_id, payment_type_id, employee_id,
	"date", customer_id, item_id, quantity,selling_price, other_discount, coupon_discount
   FROM external_customer_transaction;
COMMIT;