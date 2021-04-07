INSERT INTO ce_marital_statuses(marital_id, marital_status)
SELECT sequence_common_1.NEXTVAL, marital_status FROM
    (SELECT  marital_status FROM bl_cl.cl_customers
    GROUP BY marital_status)a ;
COMMIT;
