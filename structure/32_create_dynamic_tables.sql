-- =========================================
-- 1. Dynamic Table: Mirror of RAW_IOT with 5 min lag
-- =========================================
CREATE OR REPLACE DYNAMIC TABLE ABC_IOT_MIRROR
 TARGET_LAG = '5 MINUTES'
 WAREHOUSE = MD_TEST_WH
 AS
 SELECT *
 FROM RAW_IOT;

-- Alternative: Create a view instead for testing purposes
CREATE OR REPLACE VIEW ABC_IOT_MIRROR_VIEW AS
SELECT *
FROM RAW_IOT;

CREATE OR REPLACE DYNAMIC TABLE BC_IOT_MIRROR
 TARGET_LAG = '5 MINUTES'
 WAREHOUSE = MD_TEST_WH
 AS
 SELECT *
 FROM RAW_IOT;

CREATE OR REPLACE VIEW AB_IOT_MIRROR_VIEW_not_valide AS
SELECT *
FROM RAW_IOT;
