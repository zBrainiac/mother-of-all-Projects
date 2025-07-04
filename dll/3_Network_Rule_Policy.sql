use role accountadmin;
create database SNOW_PLATFORM_DB;
create warehouse SNOW_platform_wh_xs with warehouse_size = 'X-Small';

-- First create one to many network rules
create network rule allow_access_rule
 mode = ingress
 type = ipv4
 value_list = ('<ip_address>','<ip_address>','<ip_address>','<ip_address>','<ip_address>','<ip_address>',)
 Comment = 'Internal Private IP Ranges';

 -- Create the network policy referencing the network rule
 CREATE NETWORK POLICY corp_network_policy
   ALLOWED_NETWORK_RULE_LIST = ( 'allow_access_rule' )
   COMMENT = 'Corporate network policy' ;

   alter account set network_policy = corp_network_policy;

SHOW NETWORK POLICIES;

DESC NETWORK POLICY AZURE_NETWORK_POLICY_FOR_SCIM;
