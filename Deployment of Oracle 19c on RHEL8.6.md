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









## Installing Oracle



## Post configuration