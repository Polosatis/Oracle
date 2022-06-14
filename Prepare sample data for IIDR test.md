# Introduction

## Change some default sqlplus parameters
### Line Size
When selecting data from Oracle tables, the default line width can often be shorter than the lines of data you wish to view. This causes the text to wrap around, making it very hard to read. To avoid this problem you can change the Oracle default settings to increase the width of the lines, using the
set command.

Eg. At the SQL*Plus command line, type:
```
set linesize 200
```
 - this will change the line width to 200 characters.

You could try a few different line size settings unitl you find the size that suits you.
### Page Size
If you are selecting data from a table with hundreds of lines, it will scroll quickly up the screen until the end of the data. If your page size isn't set, this will prevent you from being able to read all of it. To avoid this problem, you can change the Oracle default setting to suit the size of your window, using the set command. However, Oracle must also be told to pause the display after each page.

Eg. At the SQL*Plus command line, type:
```
set pagesize 30
```
 - this will change the page size to 30 rows.
```
set pause on
```
 - this will cause the output to pause every 30 lines; press the enter key to continue



# Create Schema

## Create Schema using sqlplus
You should be already connected to database prior to execution of the following:
```
SQL> CREATE USER iidrsource IDENTIFIED BY iidrsource;
CREATE USER iidrsource IDENTIFIED BY iidrsource
            *
ERROR at line 1:
ORA-65096: invalid common user or role name
```
This type of the output shows that user is currently connected to CDB but not PDB. This should be altered and then user creation command should be repeated.
```
SQL> alter session set container=PDB1;

Session altered.

SQL> CREATE USER iidrsource IDENTIFIED BY iidrsource;

User created.
```
## Verify existing tablespaces
We need to search for existing tablespaces in order to use one of those for the schema data storage.
```
[oracle@oracleVM ~]$ sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Tue Jun 14 05:54:03 2022
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL> SELECT TABLESPACE_NAME, STATUS, CONTENTS FROM USER_TABLESPACES;

TABLESPACE_NAME 	       STATUS	 CONTENTS
------------------------------ --------- ---------------------
SYSTEM			       ONLINE	 PERMANENT
SYSAUX			       ONLINE	 PERMANENT
UNDOTBS1		       ONLINE	 UNDO
TEMP			       ONLINE	 TEMPORARY
USERS			       ONLINE	 PERMANENT
```
In this case there is USERS tablespace present, so we can use that for the purpose of the demo.






## Grant user privileges

```
SQL> GRANT CREATE TABLE TO iidrsource;

Grant succeeded.

SQL> GRANT CONNECT TO iidrsource;

Grant succeeded.

SQL> GRANT RESOURCE TO iidrsource;

Grant succeeded.

SQL> GRANT CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO IIDRSOURCE;

Grant succeeded.

SQL> GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE , UNLIMITED TABLESPACE TO iidrsource;

Grant succeeded.

```

## Verify the user is created
```
SQL> SELECT username, account_status FROM dba_users WHERE username='IIDRSOURCE';

USERNAME															 ACCOUNT_STATUS
-------------------------------------------------------------------------------------------------------------------------------- --------------------------------
IIDRSOURCE															 OPEN

```

Reference https://docs.oracle.com/en/cloud/paas/exadata-express-cloud/csdbp/create-database-schemas.html#GUID-955764C0-599E-4488-96EA-6E13A6FEBE9A

# Out of the box Oracle Sample data

Oracle provides some sample data which may be used for the demos. That is available by the link:

https://github.com/oracle-samples/db-sample-schemas/releases/tag/v21.1

The file from the link should be uploaded to VM and unpacked
