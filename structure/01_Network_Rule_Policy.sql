USE ROLE ACCOUNTADMIN;

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

-- Recreate the network policy
CREATE OR REPLACE NETWORK POLICY ABC_corp_network_policy
  ALLOWED_NETWORK_RULE_LIST = ('ABC_allow_access_rule')
  COMMENT = 'Corporate network policy';

-- Reassign the policy to the account
ALTER ACCOUNT SET NETWORK_POLICY = ABC_corp_network_policy;

-- Confirm
SHOW NETWORK POLICIES;
DESC NETWORK POLICY ABC_corp_network_policy;
