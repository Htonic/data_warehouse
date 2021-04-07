CREATE TABLE cl_stores(
 store_number VARCHAR2(14),
 store_name VARCHAR2(60),
 street_address VARCHAR2(232),
 city VARCHAR2(85),
 state_province VARCHAR2(14),
 country VARCHAR2(7),
 postcode VARCHAR2(12),
 phone_number VARCHAR2(20)
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