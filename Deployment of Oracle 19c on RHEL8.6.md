# Deployment of Oracle 19c on Red Hat Enterprise Linux 8.6

## Tips are taken from these sources


https://access.redhat.com/discussions/6116521

https://public-yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64/getPackage/oracle-database-preinstall-19c-1.0-2.el8.x86_64.rpm

https://docs.oracle.com/en/database/oracle/oracle-database/19/ladbi/running-oracle-universal-installer-to-install-oracle-database.html#GUID-DD4800E9-C651-4B08-A6AC-E5ECCC6512B9

https://oracle-base.com/articles/19c/oracle-db-19c-installation-on-oracle-linux-8


## Checking pre-requisites

Most comfortable way is to deploy oracle with automated script for verification of pre-requisites. This one verifies the system parameters, packages, etc and does automated updates if needed.

Original link can be found by this link:
https://access.redhat.com/discussions/6116521

Which allows to download following file:
https://public-yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64/getPackage/oracle-database-preinstall-19c-1.0-2.el8.x86_64.rpm


If you have the Linux firewall enabled, you will need to disable or configure it, as shown here. To disable it, do the following.
```
systemctl stop firewalld
systemctl disable firewalld
```
If you are not using Oracle Linux and UEK, you will need to manually disable transparent huge pages.

Create the directories in which the Oracle software will be installed.
```
mkdir -p /u01/app/oracle/product/19.0.0/dbhome_1
mkdir -p /u02/oradata
chown -R oracle:oinstall /u01 /u02
chmod -R 775 /u01 /u02
```

Create a "scripts" directory.

```
mkdir /home/oracle/scripts
```

Create an environment file called "setEnv.sh". The "$" characters are escaped using "\". If you are not creating the file with the cat command, you will need to remove the escape characters.
```
cat > /home/oracle/scripts/setEnv.sh <<EOF
# Oracle Settings
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=ol8-19.localdomain
export ORACLE_UNQNAME=cdb1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/19.0.0/dbhome_1
export ORA_INVENTORY=/u01/app/oraInventory
export ORACLE_SID=cdb1
export PDB_NAME=pdb1
export DATA_DIR=/u02/oradata

export PATH=/usr/sbin:/usr/local/bin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib
EOF
```

Add a reference to the "setEnv.sh" file at the end of the "/home/oracle/.bash_profile" file.

```
echo ". /home/oracle/scripts/setEnv.sh" >> /home/oracle/.bash_profile
```

Create a "start_all.sh" and "stop_all.sh" script that can be called from a startup/shutdown service. Make sure the ownership and permissions are correct.

```
cat > /home/oracle/scripts/start_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbstart \$ORACLE_HOME
EOF
```
```
cat > /home/oracle/scripts/stop_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbshut \$ORACLE_HOME
EOF
```
```
chown -R oracle:oinstall /home/oracle/scripts
chmod u+x /home/oracle/scripts/*.sh
```
Once the installation is complete and you've edited the "/etc/oratab", you should be able to start/stop the database with the following scripts run from the "oracle" user.
```
~/scripts/start_all.sh
~/scripts/stop_all.sh
```

## User group validation

Prior to the deployment check the oracle user groups. Those should include 
oinstall, dba, oper

This validation should be performed in 2 ways. 
1) Run 'groups' command and see if those are listed
2) Run 'groups oracle' command and see if the output lists different groups rather than in 1. 

If the groups are not present in neither outputs then run
```
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper 
```
If output is different, then those changes are not applied to user. Group output shows current status, while Group oracle output shows what's in configuration files on different levels. 

The groups command shows the groups as currently applied to your user, and the list will start with the current primary group followed by the supplementary groups from the time of login. Any changes to the sources of the data from after the time of login are not reflected in the displayed list.

The groups username command is asking Linux to calculate the groups for that user, which it will do using principally the files /etc/password and /etc/groups and then the additional sources.

To apply all changes the log-out - log-in should be performed and then validation re-run.

Otherwise the oracle silent installation script will show error that Oracle is not a part of DBA group and fail with Fatal error.


## Installing Oracle

Switch to the ORACLE_HOME directory, unzip the software directly into this path and start the Oracle Universal Installer (OUI) by issuing one of the following commands in the ORACLE_HOME directory. The interactive mode will display GUI installer screens to allow user input, while the silent mode will install the software without displaying any screens, as all required options are already specified on the command line.

 Unzip software.
```
cd $ORACLE_HOME
unzip -oq /path/to/software/LINUX.X64_193000_db_home.zip
```
Fake Oracle Linux 7.
```
export CV_ASSUME_DISTID=OEL7.6
```

Interactive mode.
```
./runInstaller
```

Silent mode.
```
./runInstaller -ignorePrereq -waitforcompletion -silent                        \
    -responseFile ${ORACLE_HOME}/install/response/db_install.rsp               \
    oracle.install.option=INSTALL_DB_SWONLY                                    \
    ORACLE_HOSTNAME=${ORACLE_HOSTNAME}                                         \
    UNIX_GROUP_NAME=oinstall                                                   \
    INVENTORY_LOCATION=${ORA_INVENTORY}                                        \
    SELECTED_LANGUAGES=en,en_GB                                                \
    ORACLE_HOME=${ORACLE_HOME}                                                 \
    ORACLE_BASE=${ORACLE_BASE}                                                 \
    oracle.install.db.InstallEdition=EE                                        \
    oracle.install.db.OSDBA_GROUP=dba                                          \
    oracle.install.db.OSBACKUPDBA_GROUP=dba                                    \
    oracle.install.db.OSDGDBA_GROUP=dba                                        \
    oracle.install.db.OSKMDBA_GROUP=dba                                        \
    oracle.install.db.OSRACDBA_GROUP=dba                                       \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 \
    DECLINE_SECURITY_UPDATES=true
```
Run the root scripts when prompted.

As a root user, execute the following script(s):
```
 1. /u01/app/oraInventory/orainstRoot.sh
        2. /u01/app/oracle/product/19.0.0/dbhome_1/root.sh
```

_____
## Database Creation

(if it has not been created while performing installation itself)

You create a database using the Database Configuration Assistant (DBCA). The interactive mode will display GUI screens to allow user input, while the silent mode will create the database without displaying any screens, as all required options are already specified on the command line.

Start the listener.
```
lsnrctl start
```

Interactive mode.
```
dbca
```
Silent mode
```
dbca -silent -createDatabase                                                   \
     -templateName General_Purpose.dbc                                         \
     -gdbname ${ORACLE_SID} -sid  ${ORACLE_SID} -responseFile NO_VALUE         \
     -characterSet AL32UTF8                                                    \
     -sysPassword SysPassword1                                                 \
     -systemPassword SysPassword1                                              \
     -createAsContainerDatabase true                                           \
     -numberOfPDBs 1                                                           \
     -pdbName ${PDB_NAME}                                                      \
     -pdbAdminPassword PdbPassword1                                            \
     -databaseType MULTIPURPOSE                                                \
     -memoryMgmtType auto_sga                                                  \
     -totalMemory 2000                                                         \
     -storageType FS                                                           \
     -datafileDestination "${DATA_DIR}"                                        \
     -redoLogFileSize 50                                                       \
     -emConfiguration NONE                                                     \
     -ignorePreReqs
```


______

## Post configuration

Edit the "/etc/oratab" file setting the restart flag for each instance to 'Y'.
```
cdb1:/u01/app/oracle/product/19.0.0/dbhome_1:Y
```
Enable Oracle Managed Files (OMF) and make sure the PDB starts when the instance starts.
```
sqlplus / as sysdba <<EOF
alter system set db_create_file_dest='${DATA_DIR}';
alter pluggable database ${PDB_NAME} save state;
exit;
EOF

```

in my case connect to
```sqlplus sys/oracle@ORCL as sysdba
```
and then in case of execution of command above the parameters are equal to:
```
DATA_DIR='/u02/oradata'
PDB_NAME=ORCLPDB
```





