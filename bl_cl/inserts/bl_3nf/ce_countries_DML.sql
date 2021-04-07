INSERT INTO ce_countries(country_id, country_name)
SELECT sequence_common_2.NEXTVAL, country FROM
    (SELECT  country FROM bl_cl.cl_stores
    GROUP BY country)a ;
COMMIT;
