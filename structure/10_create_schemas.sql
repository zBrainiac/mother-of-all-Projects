-- context:
SELECT
  CURRENT_DATABASE() AS database_name,
  CURRENT_SCHEMA() AS schema_name,
  CURRENT_USER() AS current_user,
  CURRENT_ROLE() AS current_role;

-- correct
CREATE SCHEMA IF NOT EXISTS raw_test_edertt_v001;


-- no RAW | REF prefix
CREATE SCHEMA IF NOT EXISTS test_md_123_v001;

-- version only 2-digits
CREATE SCHEMA IF NOT EXISTS test_md_123_v01;


-- no RAW | REF prefix
CREATE SCHEMA test_md_123_v002;

-- version only 2-digits
CREATE SCHEMA test_md_123_v02;



-- drop all
DROP SCHEMA raw_test_edertt_v001;
DROP SCHEMA test_md_123_v001;
DROP SCHEMA test_md_123_v002;
DROP SCHEMA test_md_123_v01;
DROP SCHEMA test_md_123_v02;