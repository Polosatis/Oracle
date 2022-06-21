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
```
[oracle@oracleVM Downloads]$ mkdir DBSample
[oracle@oracleVM Downloads]$ tar -xvf db-sample-schemas-21.1.tar.gz --directory DBSample
db-sample-schemas-21.1/
db-sample-schemas-21.1/CONTRIBUTING.md
db-sample-schemas-21.1/LICENSE.md
```

Make sure that Perl is deployed or deploy that:
```
[oracle@oracleVM Downloads]$ sudo yum install perl
Updating Subscription Management repositories.
Last metadata expiration check: 3:47:56 ago on Tue 14 Jun 2022 04:07:20 AM PDT.
Dependencies resolved.
=================================================================================================================================================================================
 Package                                      Architecture           Version                                              Repository                                        Size
=================================================================================================================================================================================
Installing:
 perl                                         x86_64                 4:5.26.3-421.el8                                     rhel-8-for-x86_64-appstream-rpms                  73 k
```
Wait until Completed message on the screen

```
[oracle@oracleVM human_resources]$ source /usr/local/bin/oraenv
ORACLE_SID = [cdb1] ? 
The Oracle base remains unchanged with value /u01/app/oracle
```
prior to executing next step make sure that current folder is the top dirrectory of sample folder holding the ```mksample.sql``` file
```
[oracle@oracleVM human_resources]$ sqlplus system/SysPassword1@PDB1

SQL*Plus: Release 19.0.0.0.0 - Production on Tue Jun 14 08:31:26 2022
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL> @mksample SysPassword1 SysPassword1 InfoServer InfoServer InfoServer InfoServer InfoServer InfoServer users temp /home/oracle/ PDB1
```
This script will take up to 10 minutes to run. After that in the home folder there will be a set of log files available for analysis.
```
[oracle@oracleVM ~]$ pwd
/home/oracle
[oracle@oracleVM ~]$ ls -la
total 204
drwx------. 19 oracle oracle    4096 Jun 14 08:45 .
drwxr-xr-x.  3 root   root        20 Jun  9 03:56 ..
-rw-rw-r--.  1 oracle oracle    2345 Jun 14 08:45 bi_v3.log
-rw-rw-r--.  1 oracle oracle    2126 Jun 14 08:44 chan_v3.log
-rw-rw-r--.  1 oracle oracle    2369 Jun 14 08:43 coun_v3.log
-rw-rw-r--.  1 oracle oracle    3609 Jun 14 08:43 cust1v3.log
-rw-rw-r--.  1 oracle oracle    2802 Jun 14 08:44 dem1v3.log
-rw-rw-r--.  1 oracle oracle    2673 Jun 14 08:44 dmsal_v3.log
-rw-r--r--.  1 oracle oracle    5508 Jun 14 08:45 ext_1v3.log
-rw-rw-r--.  1 oracle oracle    6142 Jun 14 08:39 hr_main.log
-rw-rw-r--.  1 oracle oracle    7038 Jun 14 08:42 ix_v3.log
-rw-rw-r--.  1 oracle oracle   62145 Jun 14 08:45 mkverify_v3.log
-rw-rw-r--.  1 oracle oracle    5985 Jun 14 08:41 oe_oc_v3.log
-rw-rw-r--.  1 oracle oracle     599 Jun 14 08:42 pm_main.log
-rw-rw-r--.  1 oracle oracle    5170 Jun 14 08:42 pm_p_lob.log
-rw-rw-r--.  1 oracle oracle    3667 Jun 14 08:43 prod1v3.log
-rw-rw-r--.  1 oracle oracle    2718 Jun 14 08:43 prom1v3.log
-rw-rw-r--.  1 oracle oracle    3155 Jun 14 08:44 sale1v3.log
-rw-rw-r--.  1 oracle oracle    6085 Jun 14 08:45 sh_v3.log
-rw-rw-r--.  1 oracle oracle    4794 Jun 14 08:43 time_v3.log
```

```
[oracle@oracleVM db-sample-schemas-21.1]$ sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Tue Jun 14 09:22:57 2022
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL> alter session set container=PDB1;

Session altered.

SQL> create role IIDRALL;

Role created.

```

```
BEGIN
  FOR t IN (SELECT object_name, object_type FROM all_objects WHERE owner='HR' AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE')) LOOP
    IF t.object_type IN ('TABLE','VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON HR.'||t.object_name||' TO IIDRALL';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE') THEN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON HR.'||t.object_name||' TO IIDRALL';
    END IF;
  END LOOP;
END;


BEGIN
  FOR t IN (SELECT object_name, object_type FROM all_objects WHERE owner='HR' AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE')) LOOP
    IF t.object_type IN ('TABLE','VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON HR.'||t.object_name||' TO iidrsource';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE') THEN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON HR.'||t.object_name||' TO iidrsource';
    END IF;
  END LOOP;
END;
/

BEGIN
  FOR t IN (SELECT object_name, object_type FROM all_objects WHERE owner='BI' AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE')) LOOP
    IF t.object_type IN ('TABLE','VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON BI.'||t.object_name||' TO iidrsource';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE') THEN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON BI.'||t.object_name||' TO iidrsource';
    END IF;
  END LOOP;
END;

/

BEGIN
  FOR t IN (SELECT object_name, object_type FROM all_objects WHERE owner='OE' AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE')) LOOP
    IF t.object_type IN ('TABLE','VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON OE.'||t.object_name||' TO IIDRALL';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE') THEN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON OE.'||t.object_name||' TO IIDRALL';
    END IF;
  END LOOP;
END;

/

BEGIN
  FOR t IN (SELECT object_name, object_type FROM all_objects WHERE owner='PM' AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE')) LOOP
    IF t.object_type IN ('TABLE','VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON PM.'||t.object_name||' TO IIDRALL';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE') THEN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON PM.'||t.object_name||' TO IIDRALL';
    END IF;
  END LOOP;
END;

/

BEGIN
  FOR t IN (SELECT object_name, object_type FROM all_objects WHERE owner='IX' AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE')) LOOP
    IF t.object_type IN ('TABLE','VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON IX.'||t.object_name||' TO IIDRALL';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE') THEN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON IX.'||t.object_name||' TO IIDRALL';
    END IF;
  END LOOP;
END;

/

BEGIN
  FOR t IN (SELECT object_name, object_type FROM all_objects WHERE owner='SH' AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE')) LOOP
    IF t.object_type IN ('TABLE','VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON SH.'||t.object_name||' TO IIDRALL';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE') THEN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON SH.'||t.object_name||' TO IIDRALL';
    END IF;
  END LOOP;
END;

/

BEGIN
  FOR t IN (SELECT object_name, object_type FROM all_objects WHERE owner='HR' AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE')) LOOP
    IF t.object_type IN ('TABLE','VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON HR.'||t.object_name||' TO IIDRALL';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE') THEN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON HR.'||t.object_name||' TO IIDRALL';
    END IF;
  END LOOP;
END;

/

BEGIN
  FOR t IN (SELECT object_name, object_type FROM all_objects WHERE owner IN ('HR', 'BI', 'OE', 'PM', 'IX', 'SH') AND object_type IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE')) LOOP
    IF t.object_type IN ('TABLE','VIEW') THEN
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON SOURCEUSER.'||t.object_name||' TO IIDRALL';
    ELSIF t.object_type IN ('PROCEDURE','FUNCTION','PACKAGE') THEN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON TEST1.'||t.object_name||' TO IIDRALL';
    END IF;
  END LOOP;
END;

/

```


Next to check the data we should use the previously created user IIDRSOURCE to connect to PDB1. None of the created in sample databases users has the CONNECT privilege.
```
[oracle@oracleVM db-sample-schemas-21.1]$ sqlplus IIDRSOURCE/iidrsource@PDB1

SQL*Plus: Release 19.0.0.0.0 - Production on Tue Jun 14 09:03:06 2022
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.

Last Successful login time: Tue Jun 14 2022 04:31:07 -07:00

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0
```
Based on a single table of HR schema check the content uploaded:
```



