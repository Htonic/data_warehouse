CREATE TABLE src_sales(
  coupon_id  NVARCHAR(255),
  store_id  NVARCHAR(255),
  payment_type_id  NVARCHAR(255),
  employee_id  NVARCHAR(255),
  sale_date NVARCHAR(255),
  customer_id  NVARCHAR(255),
  item_id NVARCHAR(255),
  quantity NVARCHAR(255),
  selling_price NVARCHAR(255),
  other_discount NVARCHAR(255),
  coupon_discount NVARCHAR(255)
);

INSERT INTO src_sales ( coupon_id, store_id, payment_type_id, employee_id,
  sale_date, customer_id, item_id, quantity,
  selling_price, other_discount, coupon_discount)
SELECT coupon_id, store_id, payment_type_id, employee_id,
	"date", customer_id, item_id, quantity,selling_price, other_discount, coupon_discount
   FROM external_customer_transaction;
COMMIT;