CREATE TABLE cl_sales(
  cl_sale_id INT,
  coupon_id  INT,
  store_id  INT,
  payment_type_id  INT,
  employee_id  INT,
  sale_date DATE,
  customer_id  INT,
  item_id INT,
  quantity INT,
  selling_price NUMBER(18,2),
  cost_price NUMBER(18,2),
  other_discount NUMBER(18,2),
  coupon_discount NUMBER(18,2),
  update_dt DATE
);

INSERT INTO cl_sales (cl_sale_id, coupon_id, store_id, payment_type_id, employee_id,
  sale_date, customer_id, item_id, quantity,
  selling_price, cost_price, other_discount, coupon_discount,update_dt)
SELECT BL_CL.cl_sale_seq.NEXTVAL ,CAST(coupon_id AS INT), CAST(store_id AS INT), CAST(payment_type_id AS INT) ,CAST(employee_id AS INT),
  TO_DATE(TRIM(sale_date), 'YYYY-MM-DD'),CAST(customer_id AS INT), CAST(item_id AS INT), CAST(quantity AS INT),
  TO_NUMBER(TRIM(selling_price), '9999999.99'), TO_NUMBER(TRIM(selling_price), '9999999.99') * 0.75,
  TO_NUMBER(TRIM(other_discount), '9999999.99'), 
  TO_NUMBER(substr(trim(coupon_discount), 1, LENGTH(trim(coupon_discount)) -1), '99999999.99'),
  current_Date
FROM schema_src.src_sales;
