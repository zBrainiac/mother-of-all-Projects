#!/bin/bash

# -----------------------------------------------------------------------------
# Snowflake SQL Validation Script
# Usage:
# ./sql_validation_v1.sh --CLONE_SCHEMA=I0T_CLONE --CLONE_DATABASE=MD_TEST --RELEASE_NUM=39
# -----------------------------------------------------------------------------

set -e

# --- Default values ---
CONNECTION_NAME="sfseeurope-demo_ci_user"
OUTPUT_FORMAT="csv"
HEADER="false"

# --- Parse arguments ---
for ARG in "$@"; do
  case $ARG in
    --CLONE_SCHEMA=*)
      CLONE_SCHEMA="${ARG#*=}"
      ;;
    --CLONE_DATABASE=*)
      CLONE_DATABASE="${ARG#*=}"
      ;;
    --RELEASE_NUM=*)
      RELEASE_NUM="${ARG#*=}"
      ;;
    *)
      echo "❌ Unknown argument: $ARG"
      echo "Usage: $0 --CLONE_SCHEMA=SCHEMA --CLONE_DATABASE=DATABASE --RELEASE_NUM=NUM"
      exit 1
      ;;
  esac
done

# --- Validate input ---
if [[ -z "$CLONE_SCHEMA" || -z "$CLONE_DATABASE" || -z "$RELEASE_NUM" ]]; then
  echo "❌ All arguments --CLONE_SCHEMA, --CLONE_DATABASE, and --RELEASE_NUM are required."
  echo "Usage: $0 --CLONE_SCHEMA=SCHEMA --CLONE_DATABASE=DATABASE --RELEASE_NUM=NUM"
  exit 1
fi

CLONE_SCHEMA_WITH_RELEASE="${CLONE_SCHEMA}_${RELEASE_NUM}"

# --- Helper function ---
run_test() {
  local description="$1"
  local query="$2"
  local expected="$3"

  echo "🔎 Running test: $description"
  echo "📄 Executing SQL: $query"

  raw_result=$(snowsql -c "$CONNECTION_NAME" \
                       -q "$query" \
                       -o output_format=$OUTPUT_FORMAT \
                       -o header=$HEADER \
                       -o timing=false \
                       -o friendly=false 2>/dev/null)

  result=$(echo "$raw_result" | tr -d '\r' | tail -n 1 | sed 's/^"\(.*\)"$/\1/')

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
         "SELECT COUNT(*) FROM $CLONE_DATABASE.$CLONE_SCHEMA_WITH_RELEASE.RAW_IOT;" \
         "5000"

run_test "Sensor 101 has a avg temperature = 0.10909091" \
         "SELECT avg(SENSOR_0) FROM $CLONE_DATABASE.$CLONE_SCHEMA_WITH_RELEASE.RAW_IOT WHERE SENSOR_ID = 101;" \
         "0.10909091"

run_test "No NULLs in device_id column" \
         "SELECT COUNT(*) FROM $CLONE_DATABASE.$CLONE_SCHEMA_WITH_RELEASE.RAW_IOT WHERE SENSOR_ID IS NULL;" \
         "0"

echo "✅ All tests passed successfully!"