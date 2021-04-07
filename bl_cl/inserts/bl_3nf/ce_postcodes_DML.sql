INSERT INTO ce_postcodes( postcode_id, postcode )
SELECT sequence_common_2.NEXTVAL, postcode FROM
    (SELECT  postcode FROM bl_cl.cl_stores
    GROUP BY postcode)a;
COMMIT;
