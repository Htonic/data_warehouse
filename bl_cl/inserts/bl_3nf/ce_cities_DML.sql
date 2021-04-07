INSERT INTO ce_cities(city_id, city_name, state_id)
SELECT sequence_common_2.NEXTVAL, city, cs.state_id FROM
    (SELECT  city, state_province FROM bl_cl.cl_stores
    GROUP BY city, state_province)a
JOIN ce_states cs ON cs.state_name = a.state_province;
COMMIT;