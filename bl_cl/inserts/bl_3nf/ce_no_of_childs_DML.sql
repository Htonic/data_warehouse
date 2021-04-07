INSERT INTO ce_no_of_childs(no_of_child_id, no_of_child)
SELECT sequence_common_1.NEXTVAL, no_of_children FROM
    (SELECT  no_of_children FROM bl_cl.cl_customers
    GROUP BY no_of_children)a ;
COMMIT;
