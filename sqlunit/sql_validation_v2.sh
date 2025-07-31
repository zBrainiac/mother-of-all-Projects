#!/bin/bash

# -----------------------------------------------------------------------------
# Snowflake SQL Validation using `snow` CLI
# -----------------------------------------------------------------------------
# Usage:
# ./sql_validation_v2.sh \
#   --CLONE_SCHEMA=IOT_CLONE \
#   --CLONE_DATABASE=MD_TEST \
#   --RELEASE_NUM=42 \
#   --CONNECTION_NAME=sfseeurope-demo_ci_user
#
# ./sql_validation_v2.sh --CLONE_SCHEMA=IOT_CLONE --CLONE_DATABASE=MD_TEST --RELEASE_NUM=42 --CONNECTION_NAME=sfseeurope-demo_ci_user
# -----------------------------------------------------------------------------

set -e

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
    --CONNECTION_NAME=*)
      CONNECTION_NAME="${ARG#*=}"
      ;;
    *)
      echo "❌ Unknown argument: $ARG"
      echo "Usage: $0 --CLONE_SCHEMA=... --CLONE_DATABASE=... --RELEASE_NUM=... --CONNECTION_NAME=..."
      exit 1
      ;;
  esac
done

# --- Validate inputs ---
if [[ -z "$CLONE_SCHEMA" || -z "$CLONE_DATABASE" || -z "$RELEASE_NUM" || -z "$CONNECTION_NAME" ]]; then
  echo "❌ All arguments --CLONE_SCHEMA, --CLONE_DATABASE, --RELEASE_NUM, and --CONNECTION_NAME are required."
  exit 1
fi

CLONE_SCHEMA_WITH_RELEASE="${CLONE_SCHEMA}_${RELEASE_NUM}"

# --- Helper function ---
run_test() {
  local description="$1"
  local query="$2"
  local expected="$3"

  echo -e "\n🔎 Running test: $description"
  echo "📄 Executing SQL: $query"

  local raw_output
  raw_output=$(snow sql -c "$CONNECTION_NAME" -q "$query" --format json 2>&1)
  local exit_code=$?

  echo "🪵 Raw output:"
  echo "$raw_output"
  echo "💥 Exit code: $exit_code"

  if [[ $exit_code -ne 0 ]]; then
    echo "❌ snow CLI command failed:"
    echo "$raw_output"
    exit 1
  fi

  local result
  result=$(echo "$raw_output" | jq -r '.[0].RESULT // empty')

  echo "📤 Result: $result"

  if [[ -z "$result" ]]; then
    echo "❌ No result returned. Check if the schema/table exists or if the connection failed."
    exit 1
  fi

  if [[ "$result" != "$expected" ]]; then
    echo "❌ Test failed: $description"
    echo "   Expected: $expected"
    echo "   Got:      $result"
    exit 1
  else
    echo "✅ Test passed: $description"
  fi
}

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

run_test "Row count in RAW_IOT table" \
         "SELECT COUNT(*) AS result FROM $CLONE_DATABASE.$CLONE_SCHEMA_WITH_RELEASE.RAW_IOT;" \
         "5000"

run_test "Sensor 101 has SUM of temperature / Sensor 101  = 6" \
         "SELECT SUM(SENSOR_0) AS RESULT FROM $CLONE_DATABASE.$CLONE_SCHEMA_WITH_RELEASE.RAW_IOT WHERE SENSOR_ID = 101;" \
         "6.00"

run_test "No NULLs in SENSOR_ID column" \
         "SELECT COUNT(*) AS result FROM $CLONE_DATABASE.$CLONE_SCHEMA_WITH_RELEASE.RAW_IOT WHERE SENSOR_ID IS NULL;" \
         "0"

run_test "Sensor 101 has a avg temperature = 0.10909091" \
         "SELECT AVG(SENSOR_0) AS RESULT FROM $CLONE_DATABASE.$CLONE_SCHEMA_WITH_RELEASE.RAW_IOT WHERE SENSOR_ID = 101;" \
         "0.10909091"

run_test "No NULLs in SENSOR_ID column" \
         "SELECT COUNT(*) AS RESULT FROM $CLONE_DATABASE.$CLONE_SCHEMA_WITH_RELEASE.RAW_IOT WHERE SENSOR_ID IS NULL;" \
         "0"

echo -e "\n🎉 All tests passed successfully!"
