# Introduction


in sqlplus adjust the output to cover not only 30 default characters in the line
```
SQL> set linesize 200;
```


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
