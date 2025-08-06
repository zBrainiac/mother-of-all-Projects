-- USE ROLE ACCOUNTADMIN; -- Commented out: CICD_ROLE already has necessary privileges

-- Detach the network policy from the account
ALTER ACCOUNT UNSET NETWORK_POLICY;

-- Drop the network policy that uses the rule
DROP NETWORK POLICY IF EXISTS ABC_corp_network_policy;

-- Now it's safe to drop the network rule
DROP NETWORK RULE IF EXISTS ABC_allow_access_rule;

-- (Optional) Show to confirm clean-up
SHOW NETWORK POLICIES;
SHOW NETWORK RULES;

-- Recreate objects if needed
CREATE OR REPLACE DATABASE SNOW_PLATFORM_DB;

CREATE OR REPLACE WAREHOUSE SNOW_platform_wh_xs
  WITH WAREHOUSE_SIZE = 'X-Small';

-- Recreate the network rule
CREATE OR REPLACE NETWORK RULE ABC_allow_access_rule
  MODE = ingress
  TYPE = ipv4
  VALUE_LIST = ('168.198.1.1', '57.133.204.194')
  COMMENT = 'Internal Private IP Ranges';

-- First, create the new policy (if it doesn't exist)
-- CREATE NETWORK POLICY IF NOT EXISTS ABC_corp_network_policy
--  ALLOWED_IP_LIST = ('0.0.0.0/0')  -- or your specific IP ranges
--  COMMENT = 'Updated corporate network policy';

-- Set the new policy immediately
-- ALTER ACCOUNT SET NETWORK_POLICY = 'ABC_corp_network_policy';

-- Now we can safely drop any old policies
-- (This step might not be needed if we're replacing)


-- Confirm
SHOW NETWORK POLICIES;
DESC NETWORK POLICY ABC_corp_network_policy;
