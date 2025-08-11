-- =========================================
-- 1. Dynamic Table: Mirror of IOT_RAW with 5 min lag
-- =========================================
CREATE OR REPLACE DYNAMIC TABLE ABC_IOT_MIRROR
 TARGET_LAG = '5 MINUTES'
 WAREHOUSE = MD_TEST_WH
 AS
 SELECT *
 FROM IOT_RAW;

-- Alternative: Create a view instead for testing purposes
CREATE OR REPLACE VIEW ABC_IOT_MIRROR_VIEW AS
SELECT *
FROM IOT_RAW;

CREATE OR REPLACE DYNAMIC TABLE BC_IOT_MIRROR
 TARGET_LAG = '5 MINUTES'
 WAREHOUSE = MD_TEST_WH
 AS
 SELECT *
 FROM IOT_RAW;

CREATE OR REPLACE VIEW AB_IOT_MIRROR_VIEW_not_valide AS
SELECT *
FROM IOT_RAW;
