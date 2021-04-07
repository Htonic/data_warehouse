CREATE SEQUENCE test_report_sequence
 AS BIGINT
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
;

CREATE TABLE test_report_table
(  
    test_id INT DEFAULT NEXT VALUE FOR  test_report_sequence PRIMARY KEY,
    user_session NVARCHAR(100),
    test_name NVARCHAR(100),
    test_description NVARCHAR(200),
    test_passed CHAR(1),
    test_date TIMESTAMP
);