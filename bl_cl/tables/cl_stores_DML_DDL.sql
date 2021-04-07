CREATE TABLE cl_stores(
 store_number NVARCHAR(14),
 store_name NVARCHAR(60),
 street_address NVARCHAR(232),
 city NVARCHAR(85),
 state_province NVARCHAR(14),
 country NVARCHAR(7),
 postcode NVARCHAR(12),
 phone_number NVARCHAR(20)
);


INSERT INTO cl_stores ( store_number, store_name, street_address, city,
state_province, country, postcode, phone_number)
SELECT trim(store_number), trim(store_name), trim(street_address), trim(city),
trim(state_province), trim(country), CASE WHEN postcode IS NULL THEN NULL ELSE trim(postcode) END AS postcode,
CASE WHEN phone_number IS NULL THEN NULL ELSE TRIM(phone_number) END AS phone_number FROM schema_src.src_stores WHERE ROWNUM <= 5000 ORDER BY store_number ASC;
INSERT INTO cl_stores ( store_number, store_name, street_address, city,
state_province, country, postcode, phone_number)
SELECT trim(store_number), trim(store_name), trim(street_address), trim(city),
trim(state_province), trim(country), CASE WHEN postcode IS NULL THEN NULL ELSE trim(postcode) END AS postcode,
CASE WHEN phone_number IS NULL THEN NULL ELSE TRIM(phone_number) END AS phone_number FROM schema_src.src_stores WHERE ROWNUM <= 1000 ORDER BY store_number DESC;

COMMIT;