-- =========================================
-- 1. Basic View: Selects all data from RAW_IOT
-- =========================================
CREATE OR REPLACE VIEW ABC_IOT_ALL AS
SELECT *
FROM RAW_IOT;

-- =========================================
-- 2. Filtered View: Only active sensors
-- =========================================
CREATE OR REPLACE VIEW ABC_IOT_ACTIVE AS
SELECT *
FROM RAW_IOT
WHERE SENSOR_ID = '12';

-- =========================================
-- 3. Column-Mapped View: Selected and renamed columns
-- =========================================
CREATE OR REPLACE VIEW ABC_IOT_SUMMARY AS
SELECT
    sensor_id AS id,
    SENSOR_0 AS type,
    SENSOR_1 AS timestamp,
    SENSOR_2,
    SENSOR_3
FROM RAW_IOT;


-- =========================================
-- OPTIONAL CLEANUP SECTION (Teardown)
-- =========================================
--DROP VIEW IF EXISTS ABC_IOT_ALL;
--DROP VIEW IF EXISTS ABC_IOT_ACTIVE;
--DROP VIEW IF EXISTS ABC_IOT_SUMMARY;
