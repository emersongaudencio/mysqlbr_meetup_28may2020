SET SERVEROUTPUT ON
declare
 v_count number(8) := 0;
 v_count_total number(8) := 0;
begin
 for rc1 in (select t.TABLE_NAME from user_tables t) loop
  execute immediate 'select count(1) from '||rc1.table_name into v_count;
  v_count_total := v_count_total + v_count;
  dbms_output.put_line('table: '||rc1.table_name || ' --> count: '||v_count);
 end loop;
 dbms_output.put_line('Total rows: ' ||v_count_total );
end;
/
