CREATE DIRECTORY ext_tab_dir AS '/opt/oracle/oradata/csv_files/'; 

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
)
ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
 DEFAULT DIRECTORY ext_tab_dir
 ACCESS PARAMETERS
(RECORDS DELIMITED BY NEWLINE
 SKIP 1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED  BY '"' (  
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
  coupon_discount CHAR(255)))
LOCATION ('transactions.csv')
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
)
ORGANIZATION EXTERNAL 
    (TYPE ORACLE_LOADER
 DEFAULT DIRECTORY ext_tab_dir
 ACCESS PARAMETERS
(RECORDS DELIMITED BY NEWLINE
 SKIP 1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED  BY '"' (  
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
  ))
LOCATION ('directory.csv')
);

CREATE TABLE external_customer_demographics(
    customer_id CHAR(255),
    age_range CHAR(255),
    marital_status CHAR(255),
    rented CHAR(255),
    family_size CHAR(255),
    no_of_children CHAR(255),
    income_bracket CHAR(255)

)
ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
 DEFAULT DIRECTORY ext_tab_dir
 ACCESS PARAMETERS
(RECORDS DELIMITED BY NEWLINE
 SKIP 1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED  BY '"' (  
         customer_id CHAR(255),
    age_range CHAR(255),
    marital_status CHAR(255),
    rented CHAR(255),
    family_size CHAR(255),
    no_of_children CHAR(255),
    income_bracket CHAR(255)
))
LOCATION ('customer_demographics.csv')
);


CREATE TABLE external_item_data(
    item_id CHAR(255),
    brand CHAR(255),
    brand_type CHAR(255),
    "category" CHAR(255)

)
ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
 DEFAULT DIRECTORY ext_tab_dir
 ACCESS PARAMETERS
(RECORDS DELIMITED BY NEWLINE
 SKIP 1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED  BY '"' (  
 item_id CHAR(255),
    brand CHAR(255),
    brand_type CHAR(255),
"category" CHAR(255)
))
LOCATION ('item_data.csv')
);

CREATE TABLE external_employees(
    employee_id CHAR(255),
    first_name CHAR(255),
    last_name CHAR(255),
    email CHAR(255),
    phone CHAR(255),
    age CHAR(255)
)
ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
 DEFAULT DIRECTORY ext_tab_dir
 ACCESS PARAMETERS
(RECORDS DELIMITED BY NEWLINE
    SKIP 1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED  BY '"'(  
    
    employee_id CHAR(255),
    first_name CHAR(255),
    last_name CHAR(255),
    email CHAR(255),
    phone CHAR(255),
    age CHAR(255)
))
LOCATION ('employees.csv')
);

CREATE TABLE external_payment_types(
    PAYMENT_TYPE_ID CHAR(255),
    PAYMENT_TYPE_DESC CHAR(255)
)
ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
 DEFAULT DIRECTORY ext_tab_dir
 ACCESS PARAMETERS
(RECORDS DELIMITED BY NEWLINE
    SKIP 1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED  BY '"'(  
    PAYMENT_TYPE_ID CHAR(255),
    PAYMENT_TYPE_DESC CHAR(255)
))
LOCATION ('payment_types.csv')
);

CREATE TABLE external_coupons(
    coupon_id CHAR(255),
    coupon_desc CHAR(255),
    issued_quantity CHAR(255)
)
ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
 DEFAULT DIRECTORY ext_tab_dir
 ACCESS PARAMETERS
(RECORDS DELIMITED BY NEWLINE
    SKIP 1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED  BY '"'(  
    coupon_id CHAR(255),
    coupon_desc CHAR(255),
    issued_quantity CHAR(255)
))
LOCATION ('coupons.csv')
);