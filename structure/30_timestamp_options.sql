-- context:
SELECT
  CURRENT_DATABASE() AS database_name,
  CURRENT_SCHEMA() AS schema_name,
  CURRENT_USER() AS current_user,
  CURRENT_ROLE() AS current_role;

-- Here's a Snowflake CREATE TABLE statement showcasing various possible timestamp column definitions,
-- each as a separate field, with inline comments describing each variant:



-- | Type                | UTC Behavior                                                     |
-- | ------------------- | ---------------------------------------------------------------- |
-- | **`TIMESTAMP_TZ`**  | Stores UTC timestamp **with time zone info** (best for true UTC) |
-- | **`TIMESTAMP_LTZ`** | Stores timestamp normalized to UTC, shows session local time     |
-- | **`TIMESTAMP_NTZ`** | No time zone info, raw timestamp only (not UTC)                  |



-- Insert values into timestamp example table
INSERT INTO ABC_timestamp_examples (
    ts_no_precision,
    ts_default_precision,
    ts_millisecond_precision,
    ts_microsecond_precision,
    ts_nanosecond_precision,
    ts_without_timezone,
    ts_with_timezone,
    ts_local_timezone,
    ts_with_timezone_precision,
    ts_with_timezone_max_precision,
    ts_ltz_millisecond_precision,
    ts_ltz_microsecond_precision
) VALUES (
    TO_TIMESTAMP('2025-07-12 15:30:00'),                          -- Default
    TO_TIMESTAMP('2025-07-12 15:30:00.123456789'),                -- Nanoseconds
    TO_TIMESTAMP('2025-07-12 15:30:00.123'),                      -- Milliseconds
    TO_TIMESTAMP('2025-07-12 15:30:00.123456'),                   -- Microseconds
    TO_TIMESTAMP('2025-07-12 15:30:00.123456789'),                -- Nanoseconds again
    TO_TIMESTAMP_NTZ('2025-07-12 15:30:00'),                      -- No time zone
    TO_TIMESTAMP_TZ('2025-07-12 15:30:00 +00:00'),                -- UTC with time zone
    TO_TIMESTAMP_LTZ('2025-07-12 15:30:00'),                      -- Local time zone
    TO_TIMESTAMP_TZ('2025-07-12 15:30:00.123 +01:00'),            -- TZ with milliseconds
    TO_TIMESTAMP_TZ('2025-07-12 15:30:00.123456789 +00:00'),      -- TZ with nanoseconds
    TO_TIMESTAMP_LTZ('2025-07-12 15:30:00.123'),                  -- LTZ with milliseconds
    TO_TIMESTAMP_LTZ('2025-07-12 15:30:00.123456')                -- LTZ with microseconds
);


INSERT INTO ABC_timestamp_examples (
    ts_no_precision,
    ts_default_precision,
    ts_millisecond_precision,
    ts_microsecond_precision,
    ts_nanosecond_precision,
    ts_without_timezone,
    ts_with_timezone,
    ts_local_timezone,
    ts_with_timezone_precision,
    ts_with_timezone_max_precision,
    ts_ltz_millisecond_precision,
    ts_ltz_microsecond_precision
) VALUES (
    CURRENT_TIMESTAMP,                                     -- No explicit precision
    CURRENT_TIMESTAMP,                                     -- Max precision
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP(3)),               -- Millisecond precision
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP(6)),               -- Microsecond precision
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP(9)),               -- Nanosecond precision
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP_NTZ),              -- No time zone
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP_TZ),               -- With time zone
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP_LTZ),              -- Local time zone
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP_TZ(3)),            -- TZ + millisecond
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP_TZ(9)),            -- TZ + nanosecond
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP_LTZ(3)),           -- LTZ + millisecond
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP_LTZ(6))            -- LTZ + microsecond
);
