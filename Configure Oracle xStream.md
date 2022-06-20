# Supporting Documentation for Configuration of the xStream on Oracle 19c

Here and below are the configuration steps for configuring the Real-Time Downstream Capture for xStream Out API

The advantage of real-time downstream capture over archived-log downstream capture is that real-time downstream capture reduces the amount of time required to capture changes made at the source database.

The time is reduced because the real-time downstream capture process does not need to wait for the redo log file to be archived before it can capture data from it.

https://docs.oracle.com/en/database/oracle/oracle-database/19/xstrm/configuring-xstream-out.html

configuration is aligned with "Figure 4-1 Local Capture and Outbound Server in the Same Database"

# Creation of the users and schema

follow the guidance in https://docs.oracle.com/en/database/oracle/oracle-database/19/xstrm/configuring-xstream-out.html#GUID-C0E1C4AC-994A-4F62-B580-63742C9B7128
4.1.2.1 Configure an XStream Administrator on All Databases


[root@oracleVM /]# mkdir /oracle

[root@oracleVM /]# chown oracle oracle:oinstall
[root@oracleVM /]# su - oracle
[oracle@oracleVM /]$ cd /oracle
[oracle@oracleVM oracle]$ mkdir dbs
[oracle@oracleVM oracle]$ chown oracle:oinstall dbs





 sqlplus sys/SysPassword1@CDB1 as sysdba

create a tablespace for the XStream administrator

SQL> CREATE TABLESPACE xstream_tbs DATAFILE '/oracle/dbs/xstream_tbs.dbf' 
  SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;  2  

Tablespace created.
If you are creating an XStream administrator in a CDB, then you must create the tablespace in all of the containers in the CDB, including the CDB root, all pluggable databases (PDBs), all application roots, and all application containers. The tablespace is required in all containers because the XStream administrator must be a common user and so must have access to the tablespace in any container.

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






Create a new user to act as the XStream administrator

When creating an XStream administrator in a CDB, then the XStream administrator must be a common user. Therefore, include the CONTAINER=ALL clause in the CREATE USER statement
In a CDB, when ALL is specified for the container parameter, the current container must be the CDB root (CDB$ROOT). 

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








