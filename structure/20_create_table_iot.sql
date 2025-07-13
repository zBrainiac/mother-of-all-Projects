
SELECT count(*) from RAW_IOT;

-- 🟢 Permanent Table (default)
CREATE OR REPLACE TABLE permanent_table (
    id INT,
    name STRING,
    created_at TIMESTAMP
);