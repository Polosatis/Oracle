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
## Grant user privileges

```
SQL> GRANT CREATE TABLE TO iidrsource;

Grant succeeded.
```
## Verify the user is created
```
SQL> SELECT username, account_status FROM dba_users WHERE username='IIDRSOURCE';

USERNAME															 ACCOUNT_STATUS
-------------------------------------------------------------------------------------------------------------------------------- --------------------------------
IIDRSOURCE															 OPEN

```
