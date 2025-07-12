-- correct
CREATE SCHEMA IF NOT EXISTS raw_test_edertt_v001;


-- no RAW | REF prefix
CREATE SCHEMA IF NOT EXISTS test_md_123_v001;

-- version only 2-digits
CREATE SCHEMA IF NOT EXISTS test_md_123_v01;


-- no RAW | REF prefix
CREATE SCHEMA test_md_123_v001;

-- version only 2-digits
CREATE SCHEMA test_md_123_v01;



-- drop all
DROP SCHEMA raw_test_edertt_v001;
DROP SCHEMA test_md_123_v001;
DROP SCHEMA test_md_123_v01;