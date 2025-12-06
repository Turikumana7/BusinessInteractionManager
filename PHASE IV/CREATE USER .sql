CREATE USER Claude_Admin IDENTIFIED BY Claude
DEFAULT TABLESPACE Mon_26989_Data
TEMPORARY TABLESPACE Mon_26989_Temp;

GRANT CONNECT, RESOURCE, DBA TO Claude_Admin;

SELECT username, default_tablespace, temporary_tablespace FROM dba_users WHERE username='CLAUDE_ADMIN';