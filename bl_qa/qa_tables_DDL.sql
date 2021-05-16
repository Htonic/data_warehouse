CREATE TABLE check_priority(
	priority_id INTEGER IDENTITY(1,1) PRIMARY KEY,
	priority_name NVARCHAR(60) NOT NULL,
	priority_description NVARCHAR(300) NOT NULL
);

CREATE TABLE check_status(
	status_id INTEGER IDENTITY(1,1) PRIMARY KEY,
	status_name NVARCHAR(60) NOT NULL
);

CREATE TABLE check_type(
	check_type_id INTEGER IDENTITY(1,1) PRIMARY KEY,
	check_type_name NVARCHAR(60) NOT NULL
);

CREATE TABLE stage(
	stage_id INTEGER IDENTITY(1,1) PRIMARY KEY,
	stage_name NVARCHAR(60) NOT NULL,
	stage_description NVARCHAR(300) NOT NULL	
);

 CREATE TABLE dq_checks (
	etl_check_id INTEGER IDENTITY(1,1) PRIMARY KEY,
	check_name NVARCHAR(80) NOT NULL,
	failed_perc DECIMAL(18, 2) NOT NULL,
	check_type_id INTEGER FOREIGN KEY REFERENCES check_type(check_type_id),
	status_id INTEGER FOREIGN KEY REFERENCES check_status(status_id),
	priority_id INTEGER FOREIGN KEY REFERENCES check_priority(priority_id),
	stage_id INTEGER FOREIGN KEY REFERENCES stage(stage_id),
	check_date DATE DEFAULT GETDATE() NOT NULL
);