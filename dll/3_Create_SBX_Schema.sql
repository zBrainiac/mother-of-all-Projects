/****************************************************************************************
  DESC: Sandbox User schema template
****************************************************************************************/

---------------------------------------------------------------
-- 0. INPUT the components of the names
---------------------------------------------------------------
SET scimNm = 'SGS'; -- SCIM prefix
SET beNm = 'SGS';  -- organization wide DB
SET dpNm = 'SBX';   -- Database name
SET userNm = 'MHENTON'; -- user name 
SET capabilityCd = 'WRK'; -- Workspace and Sandbox have the same set of capabilities
SET modifierNm = 'SBX';
SET timetravelDays = ''; -- leave unset so db default is used instead

---------------------------------------------------------------
-- 1. DERIVE the names from the components
---------------------------------------------------------------
SET prefixNm = $beNm || IFF(($dpNm = ''), '', '_' || $dpNm);
SET dbNm = $prefixNm; 
SET scNm = $modifierNm || '_' || $userNm;
SET sarC = 'SC_C_' || $scNm;  -- Access Role to create is all that needs to be granted
SET uarNm = $scimNm || '_SBX_' || $userNm;
set uarNm_Comment = 'Data Engineer - Sandbox User Role';
-- construct the db maint and read roles
SET afrAdmin  = $prefixNm || '_ADMIN';

set whRole = '_WH_U_SGS_SBX_ADHOC' ; -- set the warehouse role, typically the usage role.  Admins may need Operate _WH_U_SGS_SBX_ADHOC
---------------------------------------------------------------
--  Creates/Performs the following:
--      1. Functional Role - user will use this role when working in their schema
--      2. Access Role - opearte on the warehouse
--      3. Warehouse - warehouse for sandbox users
---------------------------------------------------------------

select $userNm as "User Name - userNM" 
    , $uarNm as "User Role Name - uarNM"
    , $scNM as "Schema Name - scNM"
    , $sarC as "Schema Database Role - sarC"
    , $dbnm as "Database Name - dbnm" 
    , $afrAdmin as "Role Name - afrAdmin";
-------------------------------------------------------------
-- 2. USERADMIN CREATE user agg role and assign to the user
-------------------------------------------------------------
USE ROLE USERADMIN; 

CREATE USER IF NOT EXISTS IDENTIFIER($userNm);
CREATE ROLE IF NOT EXISTS IDENTIFIER($uarNm) comment = $uarNm_Comment;
GRANT ROLE IDENTIFIER($uarNm) TO USER IDENTIFIER($userNm);
-- Grant the warehouse role to the user agg role
grant role IDENTIFIER ($whRole) to role  IDENTIFIER($uarNm);

-------------------------------------------------------------
-- 3. DELEGATED SBX ADMIN CREATE schema & access roles
-------------------------------------------------------------
USE ROLE IDENTIFIER($afrAdmin);
USE DATABASE IDENTIFIER($dbNm);

--CALL sdp_d_inf.utl_provision.provision_schema_sp($dbNm, $scNm, $timetravelDays, $purposeCd, $afrAdmin);
CREATE SCHEMA IF NOT EXISTS IDENTIFIER($scNm) WITH MANAGED ACCESS;

-- CREATE Access DataBASE ROLE
CREATE DATABASE ROLE IF NOT EXISTS IDENTIFIER($sarC);

GRANT all privileges ON SCHEMA IDENTIFIER($scNm)  TO DATABASE ROLE IDENTIFIER($sarC);

GRANT DATABASE ROLE IDENTIFIER($sarC) TO ROLE IDENTIFIER($uarNm);

---------------------------------------------------------------
-- 5. Review what has been created 
---------------------------------------------------------------
show roles;
show schemas;
show database roles in database;

---------------------------------------------------------------
-- 6.  Cleanup for rerun
--
-- Steps to run 
-- 1. Run the SET commands above in the current session
-- 2. Highlight and run the statements below
---------------------------------------------------------------
/*
USE ROLE SYSADMIN;
DROP SCHEMA IF EXISTS IDENTIFIER($scNm);
DROP DATABASE ROLE IF EXISTS IDENTIFIER($sarC);
USE ROLE USERADMIN;
DROP ROLE if exists IDENTIFIER($uarNm);
show schemas;
show Database Roles in Database;
*/