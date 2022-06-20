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

Create a new user to act as the XStream administrator

When creating an XStream administrator in a CDB, then the XStream administrator must be a common user. Therefore, include the CONTAINER=ALL clause in the CREATE USER statement:

CREATE USER c##xstrmadmin IDENTIFIED BY xstrmadmin 
  DEFAULT TABLESPACE xstream_tbs
  QUOTA UNLIMITED ON xstream_tbs
  CONTAINER=ALL;




