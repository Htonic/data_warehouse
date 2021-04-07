CREATE TABLE ce_states (
    state_id    INTEGER PRIMARY KEY,
    state_name  VARCHAR2(14) NOT NULL,
    country_id  INTEGER DEFAULT -1 NOT NULL,
    update_dt  DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_states(state_id, state_name, country_id) VALUES
(-1, 'N/A', -1);
COMMIT;