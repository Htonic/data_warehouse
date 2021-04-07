CREATE TABLE src_stores(
 store_number VARCHAR2(500),
 store_name VARCHAR2(500),
 street_address VARCHAR2(500),
 city VARCHAR2(500),
 state_province VARCHAR2(500),
 country VARCHAR2(500),
 postcode VARCHAR2(500),
 phone_number VARCHAR2(500)
);

INSERT INTO src_stores ( store_number, store_name, street_address, city,
state_province, country, postcode, phone_number)
SELECT  store_number, store_name, street_address, city,
state_province, country, postcode, phone_number FROM external_stores ;
COMMIT;