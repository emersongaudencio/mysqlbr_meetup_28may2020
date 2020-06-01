SET LINESIZE 32000;
SET PAGESIZE 40000;
SET LONG 50000;
select OBJECT_TYPE, count(1) from user_objects group by OBJECT_TYPE;

select * from v$version;

select * from v$nls_parameters;
