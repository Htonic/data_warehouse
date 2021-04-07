CREATE OR REPLACE PACKAGE bl_dm.work_with_partition
   AUTHID DEFINER
IS
    PROCEDURE drop_all_partitions;
  
END work_with_partition;
/
CREATE OR REPLACE PACKAGE BODY bl_dm.work_with_partition
IS
    PROCEDURE drop_all_partitions
    IS
        CURSOR partition_curs
        IS
          SELECT partition_name
          FROM all_tab_partitions
          WHERE table_name   = 'FCT_SALES'
          AND table_owner = 'BL_DM'
          AND partition_name <> 'PART_DEFAULT';
        part_name partition_curs%rowtype;
    BEGIN
        OPEN PARTITION_CURS;
        LOOP
            FETCH PARTITION_CURS INTO PART_NAME;
            EXIT WHEN PARTITION_CURS%NOTFOUND;
            
            EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales DROP PARTITION ' 
                || PART_NAME.partition_name;
        END LOOP;
        CLOSE PARTITION_CURS;
    END;
END;