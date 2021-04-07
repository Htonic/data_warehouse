CREATE TABLE ce_countries (
    country_id    INTEGER NOT NULL,
    country_name  NVARCHAR(7) NOT NULL,
    update_dt    DATE DEFAULT GETDATE() NOT NULL
);

INSERT INTO ce_countries(country_id, country_name) VALUES
(-1, 'N/A');
COMMIT;
