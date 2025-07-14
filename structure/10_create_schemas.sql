--old: (?i)^\s*CREATE\s+SCHEMA(?:\s+IF\s+NOT\s+EXISTS)?\s+(?!RAW_|REF_|CON_|AGG_|DP_|DM_)\S+
--new: (?i)^\s*CREATE\s+SCHEMA\s+(IF\s+NOT\s+EXISTS\s+)?(RAW_|REF_|CON_|AGG_|DP_|DM_)[a-z0-9_]+;


-- prefix naming valid
CREATE SCHEMA IF NOT EXISTS RAW_test_edertt_v001;
CREATE SCHEMA IF NOT EXISTS raw_test_edertt_v001;
CREATE SCHEMA IF NOT EXISTS DP_test_edertt_v001;
CREATE SCHEMA IF NOT EXISTS DM_test_edertt_v001;
CREATE SCHEMA IF NOT EXISTS REF_test_edertt_v001;
CREATE SCHEMA IF NOT EXISTS CON_test_edertt_v001;
CREATE SCHEMA IF NOT EXISTS AGG_test_edertt_v001;

CREATE SCHEMA RAW_test_edertt_v002;
CREATE SCHEMA raw_test_edertt_v003;

-- prefix naming not valid
CREATE SCHEMA IF NOT EXISTS test_md_123_v001;
CREATE SCHEMA IF NOT EXISTS tes_md_123_v01;
CREATE SCHEMA test_md_123_v002;


--old: (?i)^\s*CREATE\s+SCHEMA(?:\s+IF\s+NOT\s+EXISTS)?\s+\S*_v\d{3}\s*;?$
--new: (?i)^\s*CREATE\s+SCHEMA\s+(IF\s+NOT\s+EXISTS\s+)?[a-z0-9_]+_v\d{3};
--     (?i)^\s*CREATE\s+SCHEMA\s+(IF\s+NOT\s+EXISTS\s+)?[a-z0-9_]+_v\d{3};
--     (?i)^\s*CREATE\s+SCHEMA\s+(IF\s+NOT\s+EXISTS\s+)?[a-z0-9_]+_v\d{3}\s*;
--     (?i)^\s*CREATE\s+SCHEMA\s+(IF\s+NOT\s+EXISTS\s+)?[a-z0-9_]+_v\d{3}\s*;\s*$
--     (?i)^\s*CREATE\s+SCHEMA\s+(IF\s+NOT\s+EXISTS\s+)?[a-z0-9_]+_v\d{3}(?![^\s;])\s*;\s*$

-- valid
CREATE SCHEMA IF NOT EXISTS test_md_123_v001;
CREATE SCHEMA IF NOT EXISTS test_md_123_V001;

-- not valid
CREATE SCHEMA IF NOT EXISTS test_md_123_x001;
CREATE SCHEMA IF NOT EXISTS test_md_123_v001_1;
CREATE SCHEMA test_md_123_v02;
CREATE SCHEMA test_md_123;


-- invalid drop schema statements
DROP SCHEMA RAW_test_edertt_v001;
DROP SCHEMA RAW_test_edertt_v002;
DROP SCHEMA raw_test_edertt_v003;
DROP SCHEMA DP_test_edertt_v001;
DROP SCHEMA DM_test_edertt_v001;
DROP SCHEMA REF_test_edertt_v001;

-- valid drop schema statements
DROP SCHEMA IF EXISTS RAW_test_edertt_v001;
DROP SCHEMA IF EXISTS raw_test_edertt_v001;
DROP SCHEMA IF EXISTS DP_test_edertt_v001;
DROP SCHEMA IF EXISTS DM_test_edertt_v001;
DROP SCHEMA IF EXISTS REF_test_edertt_v001;
DROP SCHEMA IF EXISTS CON_test_edertt_v001;
DROP SCHEMA IF EXISTS AGG_test_edertt_v001;
DROP SCHEMA IF EXISTS test_md_123_v001;
DROP SCHEMA IF EXISTS tes_md_123_v01;
DROP SCHEMA IF EXISTS test_md_123_v002;
DROP SCHEMA IF EXISTS test_md_123_V001;
DROP SCHEMA IF EXISTS test_md_123_x001;
DROP SCHEMA IF EXISTS test_md_123_v001_1;
DROP SCHEMA IF EXISTS test_md_123_v02;
DROP SCHEMA IF EXISTS test_md_123;