/*
    DROP TABLE store_id_temp;
    DROP SEQUENCE bl_cl.sequence_store_id;
*/

CREATE SEQUENCE sequence_store_id
AS BIGINT
INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    MAXVALUE 12000
    CYCLE;
    
CREATE TABLE store_id_temp(
    store_id_sales INT,
    store_number NVARCHAR(14)
);

TRUNCATE TABLE store_id_temp;
INSERT INTO store_id_temp(store_id_sales, store_number)
SELECT NEXT VALUE FOR  sequence_store_id, store_number FROM cl_stores;



