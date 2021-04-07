INSERT INTO ce_family_sizes(family_id, family_size)
SELECT sequence_common_1.NEXTVAL, family_size FROM
    (SELECT  family_size FROM bl_cl.cl_customers
    GROUP BY family_size)a ;
COMMIT;
