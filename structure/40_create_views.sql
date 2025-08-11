-- =========================================
-- 1. Basic View: Selects all data from IOT_RAW
-- =========================================
CREATE OR REPLACE VIEW ABC_IOT_ALL AS
SELECT
   sensor_id AS id
  ,SENSOR_0 AS type
  ,SENSOR_1
  ,SENSOR_2
  ,SENSOR_3
FROM IOT_RAW;

-- =========================================
-- 2. Filtered View: Only active sensors
-- =========================================
CREATE OR REPLACE VIEW ABC_IOT_ID_12 AS
SELECT
   sensor_id AS id
  ,SENSOR_0 AS type
  ,SENSOR_1
  ,SENSOR_2
  ,SENSOR_3
FROM IOT_RAW
WHERE SENSOR_ID = '12';

-- =========================================
-- 3. Column-Mapped View: Selected and renamed columns
-- =========================================
CREATE OR REPLACE VIEW ABC_IOT_ID_102_AVG AS
SELECT AVG(SENSOR_0) as avg_102
FROM IOT_RAW
WHERE SENSOR_ID = 102;

-- =========================================
-- OPTIONAL CLEANUP SECTION (Teardown)
-- =========================================
--DROP VIEW IF EXISTS ABC_IOT_ALL;
--DROP VIEW IF EXISTS ABC_IOT_ID_12;
--DROP VIEW IF EXISTS ABC_IOT_ID_102_AVG;