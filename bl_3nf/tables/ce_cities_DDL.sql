CREATE TABLE ce_cities (
    city_id    INTEGER NOT NULL,
    city_name  NVARCHAR(85) NOT NULL,
    state_id   INTEGER DEFAULT -1 NOT NULL,
    update_dt  DATE DEFAULT GETDATE() NOT NULL
);

INSERT INTO ce_cities(city_id, city_name, state_id) VALUES
(-1, 'N/A', -1);
COMMIT;