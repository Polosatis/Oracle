# Supporting Documentation for Configuration of the xStream on Oracle 19c

Here and below are the configuration steps for configuring the Real-Time Downstream Capture for xStream Out API

The advantage of real-time downstream capture over archived-log downstream capture is that real-time downstream capture reduces the amount of time required to capture changes made at the source database.

The time is reduced because the real-time downstream capture process does not need to wait for the redo log file to be archived before it can capture data from it.

https://docs.oracle.com/en/database/oracle/oracle-database/19/xstrm/configuring-xstream-out.html

configuration is aligned with "Figure 4-1 Local Capture and Outbound Server in the Same Database"

# Creation of the users and schema

follow the guidance in https://docs.oracle.com/en/database/oracle/oracle-database/19/xstrm/configuring-xstream-out.html#GUID-C0E1C4AC-994A-4F62-B580-63742C9B7128
4.1.2.1 Configure an XStream Administrator on All Databases

