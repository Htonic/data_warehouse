CREATE SEQUENCE bl_cl.log_sequence
    INCREMENT BY 1
    START WITH 1
    MINVALUE 0
    NOMAXVALUE
    NOCYCLE
    NOCACHE
;

CREATE TABLE bl_cl.log_table
(  
    log_id INT DEFAULT bl_cl.log_sequence.nextval PRIMARY KEY,
    user_session VARCHAR2(100),
    event_description VARCHAR2(200),
    event_date TIMESTAMP
);
