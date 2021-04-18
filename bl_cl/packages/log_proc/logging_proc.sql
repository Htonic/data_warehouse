CREATE OR ALTER PROCEDURE log_event  (@event_desc NVARCHAR(200))
AS
BEGIN
    INSERT INTO log_table (user_session, event_description)
    VALUES (SYSTEM_USER, @event_desc);
END;
 


	