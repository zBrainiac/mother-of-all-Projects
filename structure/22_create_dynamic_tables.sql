-- =========================================
-- 1. Dynamic Table: Mirror of RAW_IOT with 5 min lag
-- =========================================
CREATE OR REPLACE DYNAMIC TABLE ABC_IOT_MIRROR
TARGET_LAG = '5 MINUTES'
WAREHOUSE = MD_TEST_WH
AS
SELECT *
FROM RAW_IOT;

-- =========================================
-- OPTIONAL CLEANUP SECTION (Teardown)
-- =========================================
--DROP TABLE IF EXISTS ABC_IOT_MIRROR;
