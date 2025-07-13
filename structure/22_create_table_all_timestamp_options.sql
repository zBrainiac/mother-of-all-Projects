-- Here's a Snowflake CREATE TABLE statement showcasing various possible timestamp column definitions,
-- each as a separate field, with inline comments describing each variant:



-- | Type                | UTC Behavior                                                     |
-- | ------------------- | ---------------------------------------------------------------- |
-- | **`TIMESTAMP_TZ`**  | Stores UTC timestamp **with time zone info** (best for true UTC) |
-- | **`TIMESTAMP_LTZ`** | Stores timestamp normalized to UTC, shows session local time     |
-- | **`TIMESTAMP_NTZ`** | No time zone info, raw timestamp only (not UTC)                  |



CREATE OR REPLACE TABLE ABC_timestamp_examples (
    ts_no_precision TIMESTAMP,                            -- Timestamp with default precision (usually 9 fractional seconds)
    ts_default_precision TIMESTAMP(9),                    -- Explicitly specifying default max precision (nanoseconds)
    ts_millisecond_precision TIMESTAMP(3),                -- Timestamp with milliseconds precision (3 digits fractional seconds)
    ts_microsecond_precision TIMESTAMP(6),                -- Timestamp with microseconds precision (6 digits fractional seconds)
    ts_nanosecond_precision TIMESTAMP(9),                 -- Timestamp with nanoseconds precision (9 digits fractional seconds)
    ts_without_timezone TIMESTAMP_NTZ,                     -- Timestamp without time zone (NTZ = No Time Zone)
    ts_with_timezone TIMESTAMP_TZ,                         -- Timestamp with time zone (TZ = Time Zone)
    ts_local_timezone TIMESTAMP_LTZ,                       -- Timestamp with local time zone (LTZ = Local Time Zone)
    ts_with_timezone_precision TIMESTAMP_TZ(3),           -- Timestamp with time zone and milliseconds precision
    ts_with_timezone_max_precision TIMESTAMP_TZ(9),       -- Timestamp with time zone and nanoseconds precision
    ts_ltz_millisecond_precision TIMESTAMP_LTZ(3),        -- Timestamp local time zone with milliseconds precision
    ts_ltz_microsecond_precision TIMESTAMP_LTZ(6)         -- Timestamp local time zone with microseconds precision
);





INSERT INTO timestamp_versions_table (
    event_id,
    event_ltz,
    event_ntz,
    event_tz,
    event_date,
    event_time,
    event_timestamp,
    event_timestamp_tz,
    event_timestamp_ntz,
    event_timestamp_ltz
) VALUES (
    1,
    TO_TIMESTAMP_LTZ('2025-07-12 15:30:00'),                        -- Local time zone timestamp
    TO_TIMESTAMP_NTZ('2025-07-12 15:30:00'),                        -- No time zone info timestamp
    TO_TIMESTAMP_TZ('2025-07-12 15:30:00 America/New_York'),        -- Timestamp with explicit time zone
    TO_DATE('2025-07-12'),                                          -- Date only
    TO_TIME('15:30:00'),                                            -- Time only
    TO_TIMESTAMP('2025-07-12 15:30:00'),                            -- Default timestamp (equivalent to NTZ)
    TO_TIMESTAMP_TZ('2025-07-12 15:30:00 +00:00'),                  -- Timestamp with UTC offset
    TO_TIMESTAMP_NTZ('2025-07-12 15:30:00'),                        -- Timestamp without timezone
    TO_TIMESTAMP_LTZ('2025-07-12 15:30:00')                         -- Timestamp with local timezone
);
