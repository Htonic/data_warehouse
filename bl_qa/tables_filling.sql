INSERT INTO  bl_qa.dbo.check_type(check_type_name) VALUES
	('ETL Check'),
	('Data Quality Check');

INSERT INTO  bl_qa.dbo.check_status(status_name) VALUES
	('Passed'),
	('Failed'),
	('Error during execution');

INSERT INTO  bl_qa.dbo.check_priority(priority_name, priority_description) VALUES
	('Critical', 'Issue must be resolved immediately, other tasks must be postponed.'),
	('High', 'Issue must be resolved as soon as possible, tasks with medium and low priority are postponed.'),
	('Medium', 'Issue need to be resolved in 2 weeks.'),
	('Low', 'Issue will be resolved after resolving all issues with higher priority.');


INSERT INTO  bl_qa.dbo.stage(stage_name, stage_description) VALUES
	('bl_dm', 'Denormalized layer, which is using for dashboards, analyze, etc.'),
	('bl_3nf', 'Normalized layer'),
	('bl_cl', 'The layer on which all data type conversions are performed.');