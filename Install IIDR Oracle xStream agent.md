# Introduction

Here is the step-by-step guide to install IIDR agent for Oracle xStream API

# Deployment of the IIDR Agent for Oracle xStream

Execute 

```
[oracle@oracleVM Downloads]$ bash setup-iidr-11.4.0.4-5629-linux-x86.bin 
```

Choose locale English - 2

Select ```1 - install new product```

select DataStore type - ```9 for Oracle XStream```

Select offering ```4 IBM Infosphere Data Replication```

ENTER AN ABSOLUTE PATH, OR PRESS <ENTER> TO ACCEPT THE DEFAULT
      : ```/home/oracle/agent-oracle-xstream```

Confirm installation folder

enter ```1``` to accept the license agreement

Use Default value for Instance Folder: (Default: /home/oracle/agent-oracle-xstream):

This will place the instance folder into the Agent folder

```
Press ENTER to confirm details after review of Pre-Installation Summary

Congratulations. IBM InfoSphere Data Replication has been successfully 
installed to:
/home/oracle/agent-oracle-xstream

You can launch the Configuration Tool at any time by running
   /home/oracle/agent-oracle-xstream/bin/dmconfigurets
```

# Configuring subscription for Oracle xStream
```
Launch Configuration Tool? (1=Yes, 2=No) (Default: 1): 
```
Use Launch configuration tool now

```
Welcome to the configuration tool for IBM InfoSphere Data Replication (Oracle - XStream). Use this tool to create instances of IBM InfoSphere Data Replication (Oracle - XStream).

Press ENTER to continue...

CONFIGURATION TOOL - CREATING A NEW INSTANCE
--------------------------------------------

Enter the name of the new instance: OracleXStream
Enter the server port number [11001]: 

Staging Store Disk Quota is used to limit the disk space used by IBM InfoSphere Data Replication staging Store. If this space is exhausted, this instance may run at a lower speed. The minimum value allowed is 1 GB. 

Enter the Staging Store Disk Quota for this instance (GB) [100]: 20
Enter the Maximum Memory Allowed for this instance (MB) [1024]: 
Encryption profile:

1. Manage encryption profiles

Select an encryption profile: 1

MANAGE ENCRYPTION PROFILES
--------------------------

1. Add encryption profile
2. Edit encryption profile
3. Delete encryption profile

4. Completed management of encryption profiles

Enter your selection:1
Enter an encryption profile name: none
Engine-to-engine encryption enablement:

1. Enabled
2. Disabled
3. Required
4. Always

Select the engine-to-engine encryption enablement [Enabled]: 2
Enter the path to the private key store or press ENTER for no private key store : 
Enter the path to the trust store [/home/oracle/agent-oracle-xstream/jre64/jre/lib/security/cacerts]: 
Enter the password that was used to encrypt the trust store or press ENTER to keep the same password:
Trust store type:

1. JKS (Java)
2. JCEKS (Java Cryptography Extension)
3. PKCS12 (Public-Key Cryptography Standards)

Select the trust store type [JKS (Java)]: 


MANAGE ENCRYPTION PROFILES
--------------------------

1. Add encryption profile
2. Edit encryption profile
3. Delete encryption profile

4. Completed management of encryption profiles

Enter your selection:4

Encryption profile:

1. none
2. Manage encryption profiles

Select an encryption profile: 1

Enter the path for ORACLE_HOME [/u01/app/oracle/product/19.0.0/dbhome_1]: 
Enter the path for the TNSNAMES.ORA file [/u01/app/oracle/product/19.0.0/dbhome_1/network/admin]: 
TNS Name:

1. CDB1
2. PDB1
3. Other...

Select a TNS Name: 2
Would you like to configure advanced parameters (y/n) [n]: 
Use kerberos authentication (y/n) [n]: 
Would you like to retrieve database login credentials from an external secret store through a Java user exit? (y/n) [n]: 
Enter the username: iidrsource
Enter the password:
Retrieving schema list...
Metadata schema:

Enter a database schema for metadata tables or press ENTER to list schemas:
1. ANONYMOUS
2. APPQOSSYS
3. AUDSYS
4. BI
5. C##XSTRMADMIN
6. CTXSYS
7. DBSFWUSER
8. DBSNMP
9. DIP
10. DVF
11. DVSYS
12. GGSYS
13. GSMADMIN_INTERNAL
14. GSMCATUSER


Press ENTER to continue...
15. GSMUSER
16. HR
17. IIDRMETA
18. IIDRSOURCE
19. IX
20. LBACSYS
21. MDDATA
22. MDSYS
23. OE
24. OJVMSYS
25. OLAPSYS
26. ORACLE_OCM
27. ORDDATA
28. ORDPLUGINS
29. ORDSYS


Press ENTER to continue...
30. OUTLN
31. PDBADMIN
32. PM
33. REMOTE_SCHEDULER_AGENT
34. SH
35. SI_INFORMTN_SCHEMA
36. SYS
37. SYS$UMF
38. SYSBACKUP
39. SYSDG
40. SYSKM
41. SYSRAC
42. SYSTEM
43. WMSYS
44. XDB


Press ENTER to continue...
45. XS$NULL

Select a database schema for metadata tables: 17
Log Processing Database TNS Name:

1. CDB1
2. PDB1
3. Other...

Select a TNS Name: 1
Use kerberos authentication for log processing database (y/n) [n]: 
Enter the Log Processing Database user name: c##xstrmadmin
Enter the Log Processing Database user password:
Confirm the Log Processing Database user password:

Creating a new instance. Please wait...


You are about to overwrite metadata for a previous instance of IBM InfoSphere Data Replication that appears to be removed from the system. If you overwrite the metadata, you will not be able to use previous instance of IBM InfoSphere Data Replication. Do you want to proceed (y/n)?y

Instance OracleXStream was successfully created.

Would you like to START instance OracleXStream now (y/n)?y

Starting instance OracleXStream. Please wait...

Instance OracleXStream started successfully. Press ENTER to go to the Main menu...
```
exit to console

change folder to ```/home/oracle/agent-oracle-xstream/instance/OracleXStream/log```

browse log (actual log name may be different)

```
[oracle@oracleVM log]$ pwd
/home/oracle/agent-oracle-xstream/instance/OracleXStream/log
[oracle@oracleVM log]$ head trace_dmts_1_000000.log 
1	2022-06-23 04:51:40.177	main{1}	com.datamirror.ts.util.TsTraceControl	setTraceOnUntil()	Trace turned off
2	2022-06-23 04:51:40.177	Clock{23}	com.datamirror.ts.util.TsThread	run()	Thread start
3	2022-06-23 04:51:40.187	main{1}	com.datamirror.ts.util.TsTraceControl	initTracing()	Trace times are in America/Los_Angeles timezone. Current offset: -7 hours 0 minutes
4	2022-06-23 04:51:40.187	main{1}	com.datamirror.ts.commandlinetools.shared.BaseUtility	entryPoint()	Command parameters: {selectInstance=[OracleXStream], configMode=true}
5	2022-06-23 04:51:40.187	Config Mode Listener{24}	com.datamirror.ts.util.TsThread	run()	Thread start
6	2022-06-23 04:51:40.187	main{1}	com.datamirror.ts.engine.ReplicationExecutive	startConfigModeListener()	IBM InfoSphere Data Replication started in config mode.
7	2022-06-23 04:51:40.187	main{1}	com.datamirror.ts.engine.ReplicationExecutive	init()	IBM InfoSphere Data Replication is running.
8	2022-06-23 04:51:40.187	main{1}	com.datamirror.ts.engine.ReplicationExecutive	init()	User folder: /home/oracle/agent-oracle-xstream
9	2022-06-23 04:51:40.187	main{1}	com.datamirror.ts.commandlinetools.shared.BaseUtility	entryPoint()	Return code: 0
10	2022-06-23 04:51:40.187	Config Mode Listener{24}	com.datamirror.ts.jdbcagent.main.AgentExecutive	<init>()	Agent executive started !!!
```

Last message stands for successful start of the agent


# Setting up the subscription in Management Console

In this section we setup the subsctiption to replication from Oracle XStream API to Kafka topic

## Create DataStore
open Management console

tab Access Management - DataStore Management

create new DataStore

Name ```Oracle```

Host name ```oraclevm.local```

port ```11001```

Press ```ping``` to verify connection

this will fill in the properties section of the windows

Press ```connection parameters``` button

enter DB Login

enter DB Password

Confirm DB password


Rightclick the created datastore ```Oracle```

Select Assign user - ```admin```

In the new Connection Parameters window keep ```Allow connection parameters saving``` checkbox marked

click OK

## Configure subscription

Switch to Configuration tab

Create new subscription

Name ```OracleToKafka```

Project - keep ```Default Project```

DataStores for Source - ```Oracle```, for target ```Target``` (= Kafka)

Click ```OK```

Subscription has been created. Do you want to map tables? - ```Yes```

Select Mapping type as ```Multiple Kafka mappings```

Source Tables - Schema HR (has been deployed from Oracle samples). Select 2 tables: Countries and Regions

Take a look at warning that Kafka properties have not been set for the subscription. To set the properties after mapping tables, rightclick on the subscription and select Kafka Properties from the context menu

Rightclick Subscription OracleToKafka, select Kafka properties

radio button ```ZooKeeper Server```

Host Name ```aaa``` (just any leters)

Port ```1234``` (any fake port)

click OK to close window

Rightclick Subscription ```OracleToKafka```, select ```User Exits```

User Exit Type: ```Java Class```
Configuration: 

Class Name: - insert class name from documentation. I will use the KSOP JSON formatting

Parameter: ```-file:/home/iidr/kafka1.properties```

Click OK

Configuration on subscription is complete.

# Start of subscription and verification of replication results

Start subscription by right-click on subscription name and selecting "Start subscription"

Switch to the Monitoring tab

Track how subscription status changes from state ```Refresh``` to ```Mirror Continious``` and stays in this status

Switch to Kafka instance, in my case that is ```iidr-virtual-machine```

run
```
kafka-topics --zookeeper=localhose:2181 --list
```
see output
```
iidr@iidr-virtual-machine:~$ kafka-topics --zookeeper=localhost:2181 --list
KafkaTarget-ORACLETO-commitstream
KafkaTarget-SUBSCRIP-commitstream
KafkaTopicTest
__confluent.support.metrics
__consumer_offsets
_confluent-metrics
_schemas
kafkatarget.oracleto.sourcedb.hr.countries-json
kafkatarget.oracleto.sourcedb.hr.regions-json
kafkatarget.subscrip.sourcedb.db2inst1.demo-json
```
Verify that 3 new topics have been generated: ```KafkaTarget-ORACLETO-commitstream```, ```kafkatarget.oracleto.sourcedb.hr.countries-json``` and ```kafkatarget.oracleto.sourcedb.hr.regions-json```


Check that the content of ```HR.Countries``` table has been successfully replicated to Kafka

```
iidr@iidr-virtual-machine:~$ kafka-console-consumer --bootstrap-server localhost:9092 --from-beginning --topic kafkatarget.oracleto.sourcedb.hr.countries-json
{"COUNTRY_ID":"AR","COUNTRY_NAME":{"string":"Argentina"},"REGION_ID":{"string":"2.0"}}
{"COUNTRY_ID":"AU","COUNTRY_NAME":{"string":"Australia"},"REGION_ID":{"string":"3.0"}}
{"COUNTRY_ID":"BE","COUNTRY_NAME":{"string":"Belgium"},"REGION_ID":{"string":"1.0"}}
{"COUNTRY_ID":"BR","COUNTRY_NAME":{"string":"Brazil"},"REGION_ID":{"string":"2.0"}}
{"COUNTRY_ID":"CA","COUNTRY_NAME":{"string":"Canada"},"REGION_ID":{"string":"2.0"}}
{"COUNTRY_ID":"CH","COUNTRY_NAME":{"string":"Switzerland"},"REGION_ID":{"string":"1.0"}}
{"COUNTRY_ID":"CN","COUNTRY_NAME":{"string":"China"},"REGION_ID":{"string":"3.0"}}
{"COUNTRY_ID":"DE","COUNTRY_NAME":{"string":"Germany"},"REGION_ID":{"string":"1.0"}}
{"COUNTRY_ID":"DK","COUNTRY_NAME":{"string":"Denmark"},"REGION_ID":{"string":"1.0"}}
{"COUNTRY_ID":"EG","COUNTRY_NAME":{"string":"Egypt"},"REGION_ID":{"string":"4.0"}}
{"COUNTRY_ID":"FR","COUNTRY_NAME":{"string":"France"},"REGION_ID":{"string":"1.0"}}
{"COUNTRY_ID":"IL","COUNTRY_NAME":{"string":"Israel"},"REGION_ID":{"string":"4.0"}}
{"COUNTRY_ID":"IN","COUNTRY_NAME":{"string":"India"},"REGION_ID":{"string":"3.0"}}
{"COUNTRY_ID":"IT","COUNTRY_NAME":{"string":"Italy"},"REGION_ID":{"string":"1.0"}}
{"COUNTRY_ID":"JP","COUNTRY_NAME":{"string":"Japan"},"REGION_ID":{"string":"3.0"}}
{"COUNTRY_ID":"KW","COUNTRY_NAME":{"string":"Kuwait"},"REGION_ID":{"string":"4.0"}}
{"COUNTRY_ID":"ML","COUNTRY_NAME":{"string":"Malaysia"},"REGION_ID":{"string":"3.0"}}
{"COUNTRY_ID":"MX","COUNTRY_NAME":{"string":"Mexico"},"REGION_ID":{"string":"2.0"}}
{"COUNTRY_ID":"NG","COUNTRY_NAME":{"string":"Nigeria"},"REGION_ID":{"string":"4.0"}}
{"COUNTRY_ID":"NL","COUNTRY_NAME":{"string":"Netherlands"},"REGION_ID":{"string":"1.0"}}
{"COUNTRY_ID":"SG","COUNTRY_NAME":{"string":"Singapore"},"REGION_ID":{"string":"3.0"}}
{"COUNTRY_ID":"UK","COUNTRY_NAME":{"string":"United Kingdom"},"REGION_ID":{"string":"1.0"}}
{"COUNTRY_ID":"US","COUNTRY_NAME":{"string":"United States of America"},"REGION_ID":{"string":"2.0"}}
{"COUNTRY_ID":"ZM","COUNTRY_NAME":{"string":"Zambia"},"REGION_ID":{"string":"4.0"}}
{"COUNTRY_ID":"ZW","COUNTRY_NAME":{"string":"Zimbabwe"},"REGION_ID":{"string":"4.0"}}
^CProcessed a total of 25 messages
iidr@iidr-virtual-machine:~$ 
```


# Check of the IIDR metadata on Oracle side

Verify that Metadata on IIDR has been successfully created and populated on Oracle PDB1 in schema iidrmeta

```
[oracle@oracleVM ~]$ sqlplus iidrmeta/iidrmeta@PDB1

SQL*Plus: Release 19.0.0.0.0 - Production on Thu Jun 23 06:05:46 2022
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL> select table_name from user_tables;

TABLE_NAME
--------------------------------------------------------------------------------
TS_AUTH
TS_BOOKMARK
TS_CONFAUD
```


# Profit!!


