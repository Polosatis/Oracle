# Oracle post install activities to consider
## Database Express Management Console

Database Express Management Console is not enabled


## TNSPING and TNSNAMES.ORA

tnsping won't work since the tnsnames.ora is not created. This should be done manually






## CDB vs PDB - where am I?

[oracle@oracleVM ~]$ sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Jun 13 15:14:18 2022
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL> select name, cdb, con_id from v$database;

NAME	  CDB	  CON_ID
--------- --- ----------
CDB1	  YES	       0

SQL> select dbms_xdb_config.gethttpsport() from dual;

DBMS_XDB_CONFIG.GETHTTPSPORT()
------------------------------
			     0

SQL> select instance_name, status, con_id from v$instance;

INSTANCE_NAME	 STATUS 	  CON_ID
---------------- ------------ ----------
cdb1		 OPEN		       0

SQL> select name, con_id, db_unique_name from v$database
  2  ;

NAME	      CON_ID DB_UNIQUE_NAME
--------- ---------- ------------------------------
CDB1		   0 cdb1

SQL> select dbid, con_id, name from v$pdbs
  2  ;

      DBID     CON_ID
---------- ----------
NAME
--------------------------------------------------------------------------------
1535645639	    2
PDB$SEED

2385533864	    3
PDB1

SQL> alter session set container=PDB1;

Session altered.

SQL> select dbid, con_id, name from v$pdbs;

      DBID     CON_ID
---------- ----------
NAME
--------------------------------------------------------------------------------
2385533864	    3
PDB1


SQL> alter session set container=CDB$ROOT;

Session altered.

SQL> select dbid, con_id, name from v$pdbs;

      DBID     CON_ID
---------- ----------
NAME
--------------------------------------------------------------------------------
1535645639	    2
PDB$SEED

2385533864	    3
PDB1


SQL> 





