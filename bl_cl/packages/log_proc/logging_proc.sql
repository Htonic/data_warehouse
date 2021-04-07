CREATE PROCEDURE log_event(event_desc IN VARCHAR2)
IS 
PRAGMA AUTONOMOUS_TRANSACTION;
l_user_session   VARCHAR2(200);
BEGIN
    l_user_session := user;
    INSERT INTO bl_cl.log_table (user_session, event_description, event_date)
    VALUES (l_user_session, event_desc, CURRENT_TIMESTAMP);
    COMMIT;
END;