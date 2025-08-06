--- test table creation
CREATE OR REPLACE TABLE ABC_permanent_table (
    id INT,
    name STRING,
    created_at TIMESTAMP_TZ
);

CREATE TABLE ABC_permanent_table_not_valide (
    id INT,
    name STRING,
    created_at TIMESTAMP_TZ
);

CREATE OR REPLACE TABLE AB_permanent_table_name_not_valide (
    id INT,
    name STRING,
    created_at TIMESTAMP_TZ
);


CREATE OR REPLACE TABLE permanent_table_name_not_valide (
    id INT,
    name STRING,
    created_at TIMESTAMP_TZ
);

CREATE TABLE IF NOT EXISTS AB_permanent_1_table_name_not_valide (
    id INT,
    name STRING,
    created_at TIMESTAMP_TZ
);

-- USE ROLE ACCOUNTADMIN; -- Commented out: CICD_ROLE already has necessary privileges

CREATE TABLE IF NOT EXISTS MD_TEST.IOT_REF_20250711.ABC_permanent_not_valide_db_schema_prefix (
    id INT,
    name STRING,
    created_at TIMESTAMP_TZ
);

CREATE TABLE IF NOT EXISTS IOT_REF_20250711.ABC_permanent_not_valide_schema_prefix (
    id INT,
    name STRING,
    created_at TIMESTAMP_TZ
);