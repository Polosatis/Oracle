/* _______________________________________________________ {COPYRIGHT-TOP} _____
** Licensed Materials - Property of IBM 
** IBM InfoSphere Change Data Capture
** 5724-U70
** 
** (c) Copyright IBM Corp. 2001, 2011 All rights reserved.
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

--This script does not grant dba to the cdc user.

-- create user
CREATE user <user> identified by <password> 
default tablespace <tablespace_name> temporary tablespace <temporary_tablespace_name>;

-- Grant basic roles
grant connect to <user>;
grant resource to <user>;
grant select_catalog_role to <user>;
grant unlimited tablespace to <user>;

-- Table DDL permissions
grant create any table to <user>;
grant alter any table to <user>;
grant drop any table to <user>;
grant lock any table to <user>;

-- Table DML permissions
grant select any table to <user>;
grant flashback any table to <user>;
grant insert any table to <user>;
grant update any table to <user>;
grant delete any table to <user>;

-- Index and view DDL permissions
grant create any index to <user>;
grant alter any index to <user>;
grant drop any index to <user>;
grant create any view to <user>;
grant drop any view to <user>;

-- Trigger DDL and DML permissions (only required for CDC Trigger-based)
grant create any trigger to <user>;
grant alter any trigger to <user>;
grant drop any trigger to <user>;

-- Sequence DDL and DML permissions (only required for CDC Trigger-based)
grant create any sequence to <user>;
grant select any sequence to <user>;

-- Procedure permissions
grant create any procedure to <user>;
grant execute any procedure to <user>;

-- Permission to perform select on the v_$ tables
grant select any dictionary to <user>;

-- General system views
grant select on sys.v_$database to <user>;
grant select on sys.v_$controlfile to <user>;
grant select on sys.v_$version to <user>;
grant select on sys.nls_database_parameters to <user>;

-- Archive and redo logs
grant select on sys.v_$log to <user>;
grant select on sys.v_$logfile to <user>;
grant select on sys.v_$archived_log to <user>;
grant select on sys.v_$log_history to <user>;

-- Sessions and transactions
grant alter session to <user>;
grant select on sys.v_$session to <user>;
grant select on sys.gv_$session to <user>;
grant select on sys.v_$transaction to <user>;
grant select on sys.v_$mystat to <user>;

-- Tables, indexes, columns and related views
grant select on sys.all_coll_types to <user>;
grant select on sys.all_type_attrs to <user>;
grant select on sys.dba_tables to <user>;
grant select on sys.dba_tab_comments to <user>;
grant select on sys.dba_tab_columns to <user>;
grant select on sys.dba_col_comments to <user>;
grant select on sys.dba_indexes to <user>;
grant select on sys.dba_ind_columns to <user>;
grant select on sys.all_constraints to <user>;
grant select on sys.dba_constraints to <user>;
grant select on sys.all_cons_columns to <user>;
grant select on sys.dba_cons_columns to <user>;
grant select on sys.tab$ to <user>;
grant select on sys.ind$ to <user>;
grant select on sys.lob$ to <user>;
grant select on sys.col$ to <user>;
grant select on sys.icol$ to <user>;
grant select on sys.coltype$ to <user>;
grant select on sys.attrcol$ to <user>;
grant select on sys.ccol$ to <user>;
grant select on sys.cdef$ to <user>;

-- Miscellaneous other objects
grant select on sys.obj$ to <user>;
grant select on sys.dba_mviews to <user>;
grant select on sys.dba_objects to <user>;
grant select on sys.dba_sequences to <user>;
grant select on sys.hist_head$ to <user>;
grant select on sys.resource_cost to <user>;

-- Storage
grant select on sys.dba_tablespaces to <user>;
grant select on sys.dba_rollback_segs to <user>;

-- Permissions
grant select on sys.dba_users to <user>;
grant select on sys.dba_sys_privs to <user>;
grant select on sys.dba_tab_privs to <user>;
grant select on sys.dba_profiles to <user>;
grant select on sys.dba_roles to <user>;
grant select on sys.user$ to <user>;
grant select on user_role_privs to <user>;

exit;

