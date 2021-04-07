CREATE TABLE ce_employees (
    employee_id            INTEGER NOT NULL,
    employee_natural_id  INTEGER NOT NULL,
    employee_name          NVARCHAR(80) NOT NULL,
    employee_surname       NVARCHAR(80) NOT NULL,
    age                    INTEGER NOT NULL,
    email                  NVARCHAR(80) NOT NULL,
    phone                  NVARCHAR(80) NOT NULL,
    update_dt              DATE DEFAULT GETDATE() NOT NULL
);

INSERT INTO ce_employees(employee_id, employee_natural_id, employee_name,
 employee_surname, age, email, phone) VALUES 
 (-1, -1, 'N/A',
 'N/A', 0, 'N/A', 'N/A');
COMMIT;