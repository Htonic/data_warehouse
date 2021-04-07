CREATE TABLE ce_countries (
    country_id    INTEGER PRIMARY KEY,
    country_name  VARCHAR2(7) NOT NULL,
    update_dt    DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_countries(country_id, country_name) VALUES
(-1, 'N/A');
COMMIT;
