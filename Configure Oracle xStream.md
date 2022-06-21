# Supporting Documentation for Configuration of the xStream on Oracle 19c

Here and below are the configuration steps for configuring the Real-Time Downstream Capture for xStream Out API

The advantage of real-time downstream capture over archived-log downstream capture is that real-time downstream capture reduces the amount of time required to capture changes made at the source database.

The time is reduced because the real-time downstream capture process does not need to wait for the redo log file to be archived before it can capture data from it.

https://docs.oracle.com/en/database/oracle/oracle-database/19/xstrm/configuring-xstream-out.html

configuration is aligned with "Figure 4-1 Local Capture and Outbound Server in the Same Database"

# Creation of the users and schema

follow the guidance in https://docs.oracle.com/en/database/oracle/oracle-database/19/xstrm/configuring-xstream-out.html#GUID-C0E1C4AC-994A-4F62-B580-63742C9B7128
4.1.2.1 Configure an XStream Administrator on All Databases
```
[root@oracleVM /]# mkdir /oracle
```

```
[root@oracleVM /]# chown oracle oracle:oinstall
[root@oracleVM /]# su - oracle
[oracle@oracleVM /]$ cd /oracle
[oracle@oracleVM oracle]$ mkdir dbs
[oracle@oracleVM oracle]$ chown oracle:oinstall dbs
```

```
 sqlplus sys/SysPassword1@CDB1 as sysdba

create a tablespace for the XStream administrator

SQL> CREATE TABLESPACE xstream_tbs DATAFILE '/oracle/dbs/xstream_tbs.dbf' 
  SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;  2  

Tablespace created.
```

If you are creating an XStream administrator in a CDB, then you must create the tablespace in all of the containers in the CDB, including the CDB root, all pluggable databases (PDBs), all application roots, and all application containers. The tablespace is required in all containers because the XStream administrator must be a common user and so must have access to the tablespace in any container.

```
$ sqlplus sys/SysPassword1@PDB1 as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Jun 20 09:24:09 2022
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL> CREATE TABLESPACE xstream_tbs DATAFILE '/oracle/dbs/xstream_tbs_pdb1.dbf' 
  SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;  2  

Tablespace created.
```

Create a new user to act as the XStream administrator

When creating an XStream administrator in a CDB, then the XStream administrator must be a common user. Therefore, include the CONTAINER=ALL clause in the CREATE USER statement
In a CDB, when ALL is specified for the container parameter, the current container must be the CDB root (CDB$ROOT). 
```
SQL> alter session set container=CDB$ROOT;

Session altered.

SQL> CREATE USER c##xstrmadmin IDENTIFIED BY xstrmadmin 
  DEFAULT TABLESPACE xstream_tbs
  QUOTA UNLIMITED ON xstream_tbs
  CONTAINER=ALL;  2    3    4  

User created.

SQL> GRANT CREATE SESSION, SET CONTAINER TO c##xstrmadmin CONTAINER=ALL;

Grant succeeded.

SQL> BEGIN
   DBMS_XSTREAM_AUTH.GRANT_ADMIN_PRIVILEGE(
      grantee                 => 'c##xstrmadmin',
      privilege_type          => 'CAPTURE',
      grant_select_privileges => TRUE,
      container               => 'ALL');
END;
/  2    3    4    5    6    7    8  
';4
PL/SQL procedure successfully completed.
```

User iidrsource has been created in another file (preparation of the data)

There is a need to provide this user additinal privileges. Those are located in the files which are available after Oracle xStream agent install (prior to instance creation) in the #AGENT#/Samples folder.

Files are named  createuser-ora-nodba.sql and createuser-ora-xstream.sql 
```
SQL> alter session set container=PDB1;

Session altered.


-- Grant basic roles
grant connect to iidrsource;
grant resource to iidrsource;
grant select_catalog_role to iidrsource;
grant unlimited tablespace to iidrsource;

-- Table DDL permissions
grant create any table to iidrsource;
grant alter any table to iidrsource;
grant drop any table to iidrsource;
grant lock any table to iidrsource;

-- Table DML permissions
grant select any table to iidrsource;
grant flashback any table to iidrsource;
grant insert any table to iidrsource;
grant update any table to iidrsource;
grant delete any table to iidrsource;

-- Index and view DDL permissions
grant create any index to iidrsource;
grant alter any index to iidrsource;
grant drop any index to iidrsource;
grant create any view to iidrsource;
grant drop any view to iidrsource;

-- Trigger DDL and DML permissions (only required for CDC Trigger-based)
grant create any trigger to iidrsource;
grant alter any trigger to iidrsource;
grant drop any trigger to iidrsource;

-- Sequence DDL and DML permissions (only required for CDC Trigger-based)
grant create any sequence to iidrsource;
grant select any sequence to iidrsource;

-- Procedure permissions
grant create any procedure to iidrsource;
grant execute any procedure to iidrsource;

-- Permission to perform select on the v_$ tables
grant select any dictionary to iidrsource;

-- General system views
grant select on sys.v_$database to iidrsource;
grant select on sys.v_$controlfile to iidrsource;
grant select on sys.v_$version to iidrsource;
grant select on sys.nls_database_parameters to iidrsource;

-- Archive and redo logs
grant select on sys.v_$log to iidrsource;
grant select on sys.v_$logfile to iidrsource;
grant select on sys.v_$archived_log to iidrsource;
grant select on sys.v_$log_history to iidrsource;

-- Sessions and transactions
grant alter session to iidrsource;
grant select on sys.v_$session to iidrsource;
grant select on sys.gv_$session to iidrsource;
grant select on sys.v_$transaction to iidrsource;
grant select on sys.v_$mystat to iidrsource;

-- Tables, indexes, columns and related views
grant select on sys.all_coll_types to iidrsource;
grant select on sys.all_type_attrs to iidrsource;
grant select on sys.dba_tables to iidrsource;
grant select on sys.dba_tab_comments to iidrsource;
grant select on sys.dba_tab_columns to iidrsource;
grant select on sys.dba_col_comments to iidrsource;
grant select on sys.dba_indexes to iidrsource;
grant select on sys.dba_ind_columns to iidrsource;
grant select on sys.all_constraints to iidrsource;
grant select on sys.dba_constraints to iidrsource;
grant select on sys.all_cons_columns to iidrsource;
grant select on sys.dba_cons_columns to iidrsource;
grant select on sys.tab$ to iidrsource;
grant select on sys.ind$ to iidrsource;
grant select on sys.lob$ to iidrsource;
grant select on sys.col$ to iidrsource;
grant select on sys.icol$ to iidrsource;
grant select on sys.coltype$ to iidrsource;
grant select on sys.attrcol$ to iidrsource;
grant select on sys.ccol$ to iidrsource;
grant select on sys.cdef$ to iidrsource;

-- Miscellaneous other objects
grant select on sys.obj$ to iidrsource;
grant select on sys.dba_mviews to iidrsource;
grant select on sys.dba_objects to iidrsource;
grant select on sys.dba_sequences to iidrsource;
grant select on sys.hist_head$ to iidrsource;
grant select on sys.resource_cost to iidrsource;

-- Storage
grant select on sys.dba_tablespaces to iidrsource;
grant select on sys.dba_rollback_segs to iidrsource;

-- Permissions
grant select on sys.dba_users to iidrsource;
grant select on sys.dba_sys_privs to iidrsource;
grant select on sys.dba_tab_privs to iidrsource;
grant select on sys.dba_profiles to iidrsource;
grant select on sys.dba_roles to iidrsource;
grant select on sys.user$ to iidrsource;
grant select on user_role_privs to iidrsource;

grant execute on DBMS_CAPTURE_ADM to iidrsource;

grant execute on DBMS_XSTREAM_ADM to iidrsource;
```

```
SQL> alter session set container=CDB$ROOT;

Session altered.

SQL> ALTER SYSTEM SET enable_goldengate_replication=TRUE SCOPE=BOTH;

System altered.
```


## Creation of the Meta Schema

```
SQL> CREATE USER iidrmeta IDENTIFIED BY iidrmeta;

User created.

grant create any sequence to iidrmeta;
grant select any sequence to iidrmeta;

-- Procedure permissions
grant create any procedure to iidrmeta;
grant execute any procedure to iidrmeta;

-- Permission to perform select on the v_$ tables
grant select any dictionary to iidrmeta;

-- General system views
grant select on sys.v_$database to iidrmeta;
grant select on sys.v_$controlfile to iidrmeta;
grant select on sys.v_$version to iidrmeta;
grant select on sys.nls_database_parameters to iidrmeta;

-- Archive and redo logs
grant select on sys.v_$log to iidrmeta;
grant select on sys.v_$logfile to iidrmeta;
grant select on sys.v_$archived_log to iidrmeta;
grant select on sys.v_$log_history to iidrmeta;

-- Sessions and transactions
grant alter session to iidrmeta;
grant select on sys.v_$session to iidrmeta;
grant select on sys.gv_$session to iidrmeta;
grant select on sys.v_$transaction to iidrmeta;
grant select on sys.v_$mystat to iidrmeta;

-- Tables, indexes, columns and related views
grant select on sys.all_coll_types to iidrmeta;
grant select on sys.all_type_attrs to iidrmeta;
grant select on sys.dba_tables to iidrmeta;
grant select on sys.dba_tab_comments to iidrmeta;
grant select on sys.dba_tab_columns to iidrmeta;
grant select on sys.dba_col_comments to iidrmeta;
grant select on sys.dba_indexes to iidrmeta;
grant select on sys.dba_ind_columns to iidrmeta;
grant select on sys.all_constraints to iidrmeta;
grant select on sys.dba_constraints to iidrmeta;
grant select on sys.all_cons_columns to iidrmeta;
grant select on sys.dba_cons_columns to iidrmeta;
grant select on sys.tab$ to iidrmeta;
grant select on sys.ind$ to iidrmeta;
grant select on sys.lob$ to iidrmeta;
grant select on sys.col$ to iidrmeta;
grant select on sys.icol$ to iidrmeta;
grant select on sys.coltype$ to iidrmeta;
grant select on sys.attrcol$ to iidrmeta;
grant select on sys.ccol$ to iidrmeta;
grant select on sys.cdef$ to iidrmeta;

-- Miscellaneous other objects
grant select on sys.obj$ to iidrmeta;
grant select on sys.dba_mviews to iidrmeta;
grant select on sys.dba_objects to iidrmeta;
grant select on sys.dba_sequences to iidrmeta;
grant select on sys.hist_head$ to iidrmeta;
grant select on sys.resource_cost to iidrmeta;

-- Storage
grant select on sys.dba_tablespaces to iidrmeta;
grant select on sys.dba_rollback_segs to iidrmeta;

-- Permissions
grant select on sys.dba_users to iidrmeta;
grant select on sys.dba_sys_privs to iidrmeta;
grant select on sys.dba_tab_privs to iidrmeta;
grant select on sys.dba_profiles to iidrmeta;
grant select on sys.dba_roles to iidrmeta;
grant select on sys.user$ to iidrmeta;
grant select on user_role_privs to iidrmeta;
```


# Ensure That Each Source Database Is in ARCHIVELOG Mode

Each source database that generates changes that will be captured by a capture process must be in ARCHIVELOG mode.

For downstream capture processes, the downstream database also must be in ARCHIVELOG mode if you plan to configure a real-time downstream capture process. The downstream database does not need to be in ARCHIVELOG mode if you plan to run only archived-log downstream capture processes on it.

If you are configuring XStream in an Oracle Real Application Clusters (Oracle RAC) environment, then the archived redo log files of all threads from all instances must be available to any instance running a capture process. This requirement pertains to both local and downstream capture processes.


