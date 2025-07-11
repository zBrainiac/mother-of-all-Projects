#!/bin/bash

# -----------------------------------------------------------------------------
# Snowflake SQL Validation Script
# Usage:
# ./sql_validation_v1.sh --schema=I0T_CLONE_1_37 --database=MD_TEST
# -----------------------------------------------------------------------------

set -e

# --- Default values ---
SCHEMA_NAME="I0T_CLONE_1_37"
DATABASE_NAME="MD_TEST"
CONNECTION_NAME="sfseeurope-demo_mdaeppen"
OUTPUT_FORMAT="csv"
HEADER="false"

# --- Parse arguments ---
for ARG in "$@"; do
  case $ARG in
    --schema=*)
      SCHEMA_NAME="${ARG#*=}"
      ;;
    --database=*)
      DATABASE_NAME="${ARG#*=}"
      ;;
    *)
      echo "❌ Unknown argument: $ARG"
      echo "Usage: $0 --schema=SCHEMA_NAME [--database=DATABASE_NAME]"
      exit 1
      ;;
  esac
done

# --- Validate input ---
if [[ -z "$SCHEMA_NAME" ]]; then
  echo "❌ Schema name is required."
  echo "Usage: $0 --schema=SCHEMA_NAME [--database=DATABASE_NAME]"
  exit 1
fi

# --- Helper function ---
run_test() {
  local description="$1"
  local query="$2"
  local expected="$3"

  echo "🔎 Running test: $description"
  echo "📄 Executing SQL: $query"

  # Capture and clean result (remove quotes and carriage returns)
  raw_result=$(snowsql -c "$CONNECTION_NAME" \
                       -q "$query" \
                       -o output_format=$OUTPUT_FORMAT \
                       -o header=$HEADER \
                       -o timing=false \
                       -o friendly=false 2>/dev/null)

  result=$(echo "$raw_result" | tr -d '\r' | sed 's/^"\(.*\)"$/\1/')

  echo "📤 Result: $result"

  if [[ "$result" != "$expected" ]]; then
    echo "❌ Test failed: $description"
    echo "   Expected: $expected"
    echo "   Got:      $result"
    exit 1
  else
    echo "✅ Test passed: $description"
  fi
  echo ""
}

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

run_test "Row count in RAW_IOT table" \
         "SELECT COUNT(*) FROM $DATABASE_NAME.$SCHEMA_NAME.RAW_IOT;" \
         "5000"

run_test "Device ID 1001 has temperature = 21.5" \
         "SELECT avg(SENSOR_0) FROM $DATABASE_NAME.$SCHEMA_NAME.RAW_IOT WHERE SENSOR_ID = 101;" \
         "0.10909091"

run_test "No NULLs in device_id column" \
         "SELECT COUNT(*) FROM $DATABASE_NAME.$SCHEMA_NAME.RAW_IOT WHERE SENSOR_ID IS NULL;" \
         "0"

echo "✅ All tests passed successfully!"
