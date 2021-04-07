CREATE SEQUENCE bl_cl.test_report_sequence
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOMAXVALUE
    NOCYCLE
    NOCACHE
;

CREATE TABLE bl_cl.test_report_table
(  
    test_id INT DEFAULT bl_cl.test_report_sequence.nextval PRIMARY KEY,
    user_session VARCHAR2(100),
    test_name VARCHAR2(100),
    test_description VARCHAR2(200),
    test_passed CHAR(1),
    test_date TIMESTAMP
);