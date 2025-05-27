sqlplus AQADMIN/Aqadmin123@10.235.117.196:1521/XEPDB1 <<EOF
SET PAGESIZE 0
SET LONG 1000000
SET LONGCHUNKSIZE 1000000
SET LINESIZE 1000
SET TRIMSPOOL ON
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF
SPOOL full_dump_with_data.sql

-- First, get the table DDL
SELECT DBMS_METADATA.GET_DDL('TABLE', table_name) || ';' 
FROM user_tables;

-- Now, generate INSERT statements for each table
BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    DBMS_OUTPUT.PUT_LINE('-- Data for table ' || t.table_name);
    FOR c IN (SELECT column_name FROM user_tab_columns WHERE table_name = t.table_name ORDER BY column_id) LOOP
      DBMS_OUTPUT.PUT_LINE('SELECT ''INSERT INTO ' || t.table_name || 
                         ' VALUES ('' || 
                         LISTAGG('''''''' || REPLACE(' || c.column_name || ', '''''''', '''''''''''') || '''''''', '', '') 
                         WITHIN GROUP (ORDER BY column_id) || 
                         '');'' FROM ' || t.table_name || ';');
    END LOOP;
  END LOOP;
END;
/

SPOOL OFF
EXIT
EOF