INSERT INTO bl_dm.dim_stores (store_id, store_surrogate_id, store_number, store_name,
street_address, city_name, state_or_province, country_name, postcode, phone_number, 
city_id, state_id, country_id, postcode_id)
SELECT SEQUENCE_STORES.nextval, cs.store_id, cs.store_number, cs.store_name,
cs.street_address, ci.city_name, cst.state_name, cc.country_name, cp.postcode,
cs.phone_number, ci.city_id, cst.state_id, cc.country_id, cp.postcode_id
FROM BL_3NF.ce_stores cs
JOIN BL_3NF.ce_cities ci ON ci.city_id = cs.city_id
JOIN BL_3NF.ce_states cst ON cst.state_id = ci.state_id
JOIN BL_3NF.ce_countries cc ON cc.country_id = cst.country_id
JOIN BL_3NF.ce_postcodes cp ON cp.postcode_id = cs.postcode_id;
COMMIT;
