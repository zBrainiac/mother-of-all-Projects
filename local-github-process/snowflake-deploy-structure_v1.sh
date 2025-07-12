#!/bin/bash

# -----------------------------------------------------------------------------
# Executes all SQL files under the structure folder of a given project
# Usage:
# ./snowflake-deploy-structure_v1.sh --PROJECT_KEY=mother-of-all-Projects
# -----------------------------------------------------------------------------

set -e

# --- Default values ---
CONNECTION_NAME="sfseeurope-demo_ci_user"
BASE_WORKSPACE="/Users/mdaeppen/workspace"

# --- Parse arguments ---
for ARG in "$@"; do
  case $ARG in
    --PROJECT_KEY=*)
      PROJECT_KEY="${ARG#*=}"
      ;;
    *)
      echo "❌ Unknown argument: $ARG"
      echo "Usage: $0 --PROJECT_KEY=name-of-project"
      exit 1
      ;;
  esac
done

# --- Validate input ---
if [[ -z "$PROJECT_KEY" ]]; then
  echo "❌ Missing required argument: --PROJECT_KEY"
  exit 1
fi

PROJECT_DIR="$BASE_WORKSPACE/$PROJECT_KEY"
SQL_DIR="$PROJECT_DIR/structure"

if [[ ! -d "$SQL_DIR" ]]; then
  echo "❌ Structure folder not found: $SQL_DIR"
  exit 1
fi

echo "📂 Scanning for SQL files in: $SQL_DIR"

# --- Find and sort SQL files ---
SQL_FILES=$(find "$SQL_DIR" -type f -name "*.sql" | sort)

if [[ -z "$SQL_FILES" ]]; then
  echo "⚠️ No SQL files found in $SQL_DIR"
  exit 0
fi

# --- Execute each SQL file ---
for FILE in $SQL_FILES; do
  echo "📄 Executing: $FILE"

  snowsql -c "$CONNECTION_NAME" -f "$FILE" -o exit_on_error=true 2>&1
  RESULT=$?

  if [[ $RESULT -ne 0 ]]; then
    echo "❌ Execution failed for: $FILE"
    echo "⛔️ Aborting remaining scripts."
    exit 1
  else
    echo "✅ Success: $FILE"
  fi

  echo ""
done

echo "🎉 All SQL scripts executed successfully!"
