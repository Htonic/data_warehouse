INSERT INTO ce_states(state_id, state_name, country_id)
SELECT sequence_common_2.NEXTVAL, state_province, cc.country_id FROM
    (SELECT  state_province, country FROM bl_cl.cl_stores
    GROUP BY state_province, country)a
JOIN ce_countries cc ON cc.country_name = a.country;
COMMIT;
