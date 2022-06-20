/* _______________________________________________________ {COPYRIGHT-TOP} _____
** Licensed Materials - Property of IBM 
** IBM InfoSphere Change Data Capture
** 5724-U70
** 
** (c) Copyright IBM Corp. 2001, 2021 All rights reserved.
** 
** The following sample of source code ("Sample") is owned by International 
** Business Machines Corporation or one of its subsidiaries ("IBM") and is 
** copyrighted and licensed, not sold. You may use, copy, modify, and 
** distribute the Sample in any form without payment to IBM.
** 
** The Sample code is provided to you on an "AS IS" basis, without warranty of 
** any kind. IBM HEREBY EXPRESSLY DISCLAIMS ALL WARRANTIES, EITHER EXPRESS OR 
** IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
** MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. Some jurisdictions do 
** not allow for the exclusion or limitation of implied warranties, so the above 
** limitations or exclusions may not apply to you. IBM shall not be liable for 
** any damages you suffer as a result of using, copying, modifying or 
** distributing the Sample, even if IBM has been advised of the possibility of 
** such damages.
 * ________________________________________________________ {COPYRIGHT-END} _____*/

-- This script is a continuation of createuser-ora-nodba.sql script with 
-- additional changes needed for CDC user as well as XStream Log
-- Processing Database user. Process all needed privileges from the script
-- createuser-ora-nodba.sql prior to continuing with this script.


-- XStream privileges on CDC User

-- Expected to be used for DBMS_CAPTURE_ADM.BUILD
-- to define XStream Capture initialization points

grant execute on DBMS_CAPTURE_ADM to <user>;

-- Optional privilege that is expected to be used on
-- the target engine required for Recursion Prevention
-- in Bidirectional replication.

grant execute on DBMS_XSTREAM_ADM to <user>;

-- Enable enable_goldengate_replication

-- You need to set the enable_goldengate_replication system parameter on your source 
-- database to enable XStream replication capability in Oracle.

ALTER SYSTEM SET enable_goldengate_replication=TRUE SCOPE=BOTH; 

-- to enable the enable_goldengate_replication system parameter. 
-- All instances in Oracle RAC must have the same setting. Refer to Oracle documentation 
-- for further understanding on the impact of enabling this parameter on your database.


-- Setting up Oracle XStream user account.

-- Most work in CDC replication is done using the Oracle user account. 
-- When CDC replication needs to interact with Oracle XStream it will use the Oracle XStream account. 
-- An Oracle XStream account needs sufficient privileges to comply with Oracle XStream user requirements. 
-- In a Pluggable database environment, the Oracle user account has all the granted access to the 
-- Pluggable database when replication is configured for a pluggable database, whereas the XStream 
-- user account has to be defined in the root container database as per Oracle XStream requirements. 
-- All Oracle XStream related objects are defined and managed in the container database in this case. 

CALL DBMS_XSTREAM_AUTH.GRANT_ADMIN_PRIVILEGE(
  grantee                 => <Log Processing Database User>,
  privilege_type          => 'CAPTURE');

exit;

