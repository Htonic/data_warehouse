CREATE TABLE src_stores(
 store_number NVARCHAR(500),
 store_name NVARCHAR(500),
 street_address NVARCHAR(500),
 city NVARCHAR(500),
 state_province NVARCHAR(500),
 country NVARCHAR(500),
 postcode NVARCHAR(500),
 phone_number NVARCHAR(500)
);

INSERT INTO src_stores ( store_number, store_name, street_address, city,
state_province, country, postcode, phone_number)
SELECT  store_number, store_name, street_address, city,
state_province, country, postcode, phone_number FROM external_stores ;
COMMIT;