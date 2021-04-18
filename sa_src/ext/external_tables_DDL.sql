 CREATE TABLE external_customer_transaction(
  coupon_id  CHAR(255),
  store_id  CHAR(255),
  payment_type_id  CHAR(255),
  employee_id  CHAR(255),
  "date" CHAR(255),
  customer_id  CHAR(255),
  item_id CHAR(255),
  quantity CHAR(255),
  selling_price CHAR(255),
  other_discount CHAR(255),
  coupon_discount CHAR(255)
);

 BULK INSERT external_customer_transaction
    FROM 'C:\Users\相忮隲Desktop\diploma\source_files\transactions.csv'
    WITH
    (
	FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK,
	KEEPNULLS 
    );


CREATE TABLE external_stores(
  brand CHAR(500),
  store_number CHAR(500),
  store_name CHAR(500),
  ownership_type CHAR(500),
  street_address CHAR(500),
  city CHAR(500),
  state_province CHAR(500),
  country CHAR(500),
  postcode CHAR(500),
  phone_number CHAR(500),
  longitude CHAR(500),
  latitude CHAR(500)
);


 BULK INSERT external_stores
    FROM 'C:\Users\相忮隲Desktop\diploma\source_files\directory.csv'
    WITH
    (
	FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK,
	KEEPNULLS 
    );




CREATE TABLE external_customer_demographics(
    customer_id CHAR(255),
    age_range CHAR(255),
    marital_status CHAR(255),
    rented CHAR(255),
    family_size CHAR(255),
    no_of_children CHAR(255),
    income_bracket CHAR(255)

);

 BULK INSERT external_customer_demographics
    FROM 'C:\Users\相忮隲Desktop\diploma\source_files\customer_demographics.csv'
    WITH
    (
	FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK,
	KEEPNULLS 
    );


CREATE TABLE external_item_data(
    item_id CHAR(255),
    brand CHAR(255),
    brand_type CHAR(255),
    "category" CHAR(255)
);
BULK INSERT external_item_data
    FROM 'C:\Users\相忮隲Desktop\diploma\source_files\item_data.csv'
    WITH
    (
	FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK,
	KEEPNULLS 
    );

CREATE TABLE external_employees(
    employee_id CHAR(255),
    first_name CHAR(255),
    last_name CHAR(255),
    email CHAR(255),
    phone CHAR(255),
    age CHAR(255)
);
BULK INSERT external_employees
    FROM 'C:\Users\相忮隲Desktop\diploma\source_files\employees.csv'
    WITH
    (
	FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK,
	KEEPNULLS 
    );


CREATE TABLE external_payment_types(
    PAYMENT_TYPE_ID CHAR(255),
    PAYMENT_TYPE_DESC CHAR(255)
);
BULK INSERT external_payment_types
    FROM 'C:\Users\相忮隲Desktop\diploma\source_files\payment_types.csv'
    WITH
    (
	FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK,
	KEEPNULLS 
    );


CREATE TABLE external_coupons(
    coupon_id CHAR(255),
    coupon_desc CHAR(255),
    issued_quantity CHAR(255)
);
BULK INSERT external_coupons
    FROM 'C:\Users\相忮隲Desktop\diploma\source_files\coupons.csv'
    WITH
    (
	FORMAT='CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK,
	KEEPNULLS 
    );