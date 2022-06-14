# Oracle errors list

## ORA-65096
99.9% of the time the error ORA-65096: invalid common user or role name means you are logged into the CDB when you should be logged into a PDB. For example, if you used the default 19c installation settings, you should login to ORCLPDB (the PDB) instead of ORCL (the CDB).
___

## ORA-01078 - LRM-00109
ORA-01078: failure in processing system parameters LRM-00109: could not open parameter file

in my case the file init... .ora was missing in $ORACLE_HOME/dbs/


Oracle doesnt startup in sqlplus using STARTUP command
Same as start.sh script is not working correctly

https://docs.oracle.com/database/121/UNXAR/strt_stp.htm#UNXAR417


The isssue it that there is invalid entry in the /etc/oratab.

As dbstart script suggests, to configure, update /etc/oratab with instances that need to be started up. The entries are of the form:
```
$ORACLE_SID:$ORACLE_HOME:<N|Y|W>:
```
Sample entry:
```
main:/usr/lib/oracle/emagent_10g:Y 
```
if to browse content of dbstart.sh in $ORACLE_HOME/bin, the content says that only databases will be started where the `Y` is in the end of the line of that file



´´´

´´´

