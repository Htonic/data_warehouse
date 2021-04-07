CREATE TABLE ce_employees (
    employee_id            INTEGER PRIMARY KEY,
    employee_natural_id  INTEGER NOT NULL,
    employee_name          VARCHAR2(80) NOT NULL,
    employee_surname       VARCHAR2(80) NOT NULL,
    age                    INTEGER NOT NULL,
    email                  VARCHAR2(80) NOT NULL,
    phone                  VARCHAR2(80) NOT NULL,
    update_dt              DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_employees(employee_id, employee_natural_id, employee_name,
 employee_surname, age, email, phone) VALUES 
 (-1, -1, 'N/A',
 'N/A', 0, 'N/A', 'N/A');
COMMIT;