DROP PROCEDURE IF EXISTS report_schema;
DELIMITER $$
CREATE PROCEDURE report_schema (IN p_schema_name varchar(50))
BEGIN
Select
(select schema_name from information_schema.schemata where schema_name=p_schema_name) as "DATABASE_NAME",
(SELECT Round( Sum( data_length + index_length ) / 1024 / 1024, 2 )
FROM information_schema.tables
WHERE table_schema=p_schema_name
GROUP BY table_schema) as "SIZE_DB_MB",
(select count(*) from information_schema.tables where table_schema=p_schema_name and table_type='base table') as "TABLES_COUNT",
(select count(*) from information_schema.statistics where table_schema=p_schema_name) as "INDEXES_COUNT",
(select count(*) from information_schema.views where table_schema=p_schema_name) as "VIEWS_COUNT",
(select count(*) from information_schema.routines where routine_type ='FUNCTION' and routine_schema=p_schema_name) as "FUNCTIONS_COUNT",
(select COUNT(*) from information_schema.routines where routine_type ='PROCEDURE' and routine_schema=p_schema_name) as "PROCEDURES_COUNT",
(select count(*) from information_schema.triggers where trigger_schema=p_schema_name) as "TRIGGERS_COUNT",
(select count(*) from information_schema.events where event_schema=p_schema_name) as "EVENTS_COUNT",
(select default_collation_name from information_schema.schemata where schema_name=p_schema_name)"DEFAULT_COLLATION_DATABASE",
(select default_character_set_name from information_schema.schemata where schema_name=p_schema_name)"DEFAULT_CHARSET_DATABASE",
(select sum((select count(*) from information_schema.tables where table_schema=p_schema_name and table_type='base table')+(select count(*) from information_schema.statistics where table_schema=p_schema_name)+(select count(*) from information_schema.views where table_schema=p_schema_name)+(select count(*) from information_schema.routines where routine_type ='FUNCTION' and routine_schema=p_schema_name)+(select COUNT(*) from information_schema.routines where routine_type ='PROCEDURE' and routine_schema=p_schema_name)+(select count(*) from information_schema.triggers where trigger_schema=p_schema_name)+(select count(*) from information_schema.events where event_schema=p_schema_name))) as "TOTAL_OBJECTS_DATABASE";
END $$
DELIMITER ;
