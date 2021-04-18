CREATE SEQUENCE log_sequence
	AS BIGINT
	INCREMENT BY 1
    START WITH 1
    MINVALUE 0;

CREATE TABLE log_table
(  
    log_id INT DEFAULT NEXT VALUE FOR log_sequence,
    user_session NVARCHAR(100),
    event_description NVARCHAR(200),
    event_date DATETIME  DEFAULT CURRENT_TIMESTAMP
);
