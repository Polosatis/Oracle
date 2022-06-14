# Oracle post install activities to consider
## Database Express Management Console

Database Express Management Console is not enabled
```
SQL> select dbms_xdb_config.gethttpsport() from dual;

DBMS_XDB_CONFIG.GETHTTPSPORT()
------------------------------
			     0
```

## TNSPING and TNSNAMES.ORA

tnsping won't work since the tnsnames.ora is not created. This should be done manually
```
[oracle@oracleVM admin]$ pwd
/u01/app/oracle/product/19.0.0/dbhome_1/network/admin
[oracle@oracleVM admin]$ ls -la
total 8
drwxr-xr-x.  3 oracle oracle   59 Jun 13 14:34 .
drwxr-xr-x. 10 oracle oracle  106 Apr 17  2019 ..
drwxr-xr-x.  2 oracle oracle   64 Apr 17  2019 samples
-rw-r--r--.  1 oracle oracle 1536 Feb 13  2018 shrept.lst
-rw-r--r--.  1 oracle oracle 1424 Jun 13 14:34 tnsnames.ora
```

```
[oracle@oracleVM admin]$ cat tnsnames.ora 
# This file contains the syntax information for 
# the entries to be put in any tnsnames.ora file
# The entries in this file are need based. 
# There are no defaults for entries in this file
# that Sqlnet/Net3 use that need to be overridden 
#
# Typically you could have two tnsnames.ora files
# in the system, one that is set for the entire system
# and is called the system tnsnames.ora file, and a
# second file that is used by each user locally so that
# he can override the definitions dictated by the system
# tnsnames.ora file.

# The entries in tnsnames.ora are an alternative to using
# the names server with the onames adapter.
# They are a collection of aliases for the addresses that 
# the listener(s) is(are) listening for a database or 
# several databases.

# The following is the general syntax for any entry in 
# a tnsnames.ora file. There could be several such entries 
# tailored to the user's needs.

CDB1 =
   (DESCRIPTION =
     (ADDRESS_LIST =
       (ADDRESS =
         (PROTOCOL = TCP)
          (HOST = oracleVM)
         (PORT = 1521)
       )
     )
     (CONNECT_DATA =
        (SERVICE_NAME = CDB1)
       (INSTANCE_NAME = CDB1)
     )
   )

PDB1 =
   (DESCRIPTION =
     (ADDRESS_LIST =
       (ADDRESS =
         (PROTOCOL = TCP)
          (HOST = oracleVM)
         (PORT = 1521)
       )
     )
     (CONNECT_DATA =
        (SERVICE_NAME = PDB1)
     )
   )
[oracle@oracleVM admin]$ 
```




## CDB vs PDB - where am I?
```
[oracle@oracleVM ~]$ sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Jun 13 15:14:18 2022
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0
```
v$database and v$instance queries can't show details on where we are currently logged into

```
SQL> select name, cdb, con_id from v$database;

NAME	  CDB	  CON_ID
--------- --- ----------
CDB1	  YES	       0



SQL> select instance_name, status, con_id from v$instance;

INSTANCE_NAME	 STATUS 	  CON_ID
---------------- ------------ ----------
cdb1		 OPEN		       0

SQL> select name, con_id, db_unique_name from v$database
  2  ;

NAME	      CON_ID DB_UNIQUE_NAME
--------- ---------- ------------------------------
CDB1		   0 cdb1
```
There is a way to figure that out using:

```
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
```
CON_ID shows both 2 and 3 -> we are in CDB.

we can switch to PDB by:
```
SQL> alter session set container=PDB1;

Session altered.

SQL> select dbid, con_id, name from v$pdbs;

      DBID     CON_ID
---------- ----------
NAME
--------------------------------------------------------------------------------
2385533864	    3
PDB1
```
CON_ID is only 3 now, so we are in PDB.
We can switch back to CDB:
```
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
```
Alternative option

```
PDB
sqlplus system@SJWPDB01

SQL> select sys_context('USERENV','CON_NAME') CON_NAME,
            sys_context('USERENV','CON_ID') CON_ID,
            sys_context('USERENV','DB_NAME') DB_NAME from DUAL;

CON_NAME   CON_ID     DB_NAME
---------- ---------- ----------
SJWPDB01   3          SJW12C01
```
Pay attention to the DB_NAME. It will always return the name of the (Root) Container Database. You may considered the CON_ID. Don’t be confused – CON_ID 0 means the whole Multitenant Database and 1 is reserved for the Root Container. CON_ID 2 is always PDB$SEED. Everything else from CON_ID 3 up is a Pluggable Databases.

Having that in mind and with a bit of DECODE you get the current database name and if you are connected to a CDB or PDB:


Reference: https://www.carajandb.com/en/blog/2017/help-where-am-i-cdb-or-pdb-and-which-db-anyway/



