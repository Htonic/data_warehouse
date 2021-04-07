/*
    DROP TABLE store_id_temp;
    DROP SEQUENCE bl_cl.sequence_store_id;
*/

CREATE SEQUENCE bl_cl.sequence_store_id
INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    MAXVALUE 12000
    CYCLE
    NOCACHE;
    
CREATE TABLE store_id_temp(
    store_id_sales INT,
    store_number VARCHAR(14)
);

TRUNCATE TABLE store_id_temp;
INSERT INTO store_id_temp(store_id_sales, store_number)
SELECT sequence_store_id.NEXTVAL, store_number FROM cl_stores;
INSERT INTO store_id_temp(store_id_sales, store_number)
SELECT sequence_store_id.NEXTVAL, store_number FROM cl_stores ;



