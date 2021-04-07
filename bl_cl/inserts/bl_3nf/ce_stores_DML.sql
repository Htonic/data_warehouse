INSERT INTO ce_stores(store_id, store_number,
    store_name,street_address,
    phone_number,city_id,postcode_id)
SELECT stores.NEXTVAL, ss.store_number, ss.store_name, ss.street_address, ss.phone_number,
ci.city_id,cp.postcode_id FROM bl_cl.cl_stores ss
JOIN ce_postcodes cp ON ss.postcode = cp.postcode
JOIN ce_cities ci ON ci.city_name = ss.city
JOIN ce_states cs ON cs.state_id = ci.state_id
JOIN ce_countries ccount ON ccount.country_id = cs.country_id
WHERE cs.state_name = ss.state_province
AND ccount.country_name = ss.country;
COMMIT;
