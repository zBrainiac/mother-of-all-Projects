#!/bin/bash

# -----------------------------------------------------------------------------
# Usage:
# -----------------------------------------------------------------------------

# Parse named parameters
for ARG in "$@"; do
  case $ARG in
    --SOURCE_DATABASE=*)
      SOURCE_DATABASE="${ARG#*=}"
      ;;
    --SOURCE_SCHEMA=*)
      SOURCE_SCHEMA="${ARG#*=}"
      ;;
    --CLONE_DATABASE=*)
      CLONE_DATABASE="${ARG#*=}"
      ;;
    --CLONE_SCHEMA=*)
      CLONE_SCHEMA="${ARG#*=}"
      ;;
    --RELEASE_NUM=*)
      RELEASE_NUM="${ARG#*=}"
      ;;
    *)
      echo "❌ Unknown argument: $ARG"
      exit 1
      ;;
  esac
done

# Validate input
if [[ -z "$SOURCE_DATABASE" || -z "$SOURCE_SCHEMA" || -z "$CLONE_DATABASE" || -z "$CLONE_SCHEMA" || -z "$RELEASE_NUM" ]]; then
  echo "❌ Missing required arguments."
  echo "Usage: $0 --SOURCE_DATABASE=... --SOURCE_SCHEMA=... --CLONE_DATABASE=... --CLONE_SCHEMA=... --RELEASE_NUM=..."
  exit 1
fi

CLONE_SCHEMA_WITH_RELEASE="${CLONE_SCHEMA}_${RELEASE_NUM}"

# pull latest commit from git
echo "🔗 Connecting to Snowflake and starting the clone process..."
echo "📋 Pull latest commit from git #_$CLONE_SCHEMA_WITH_RELEASE"

# pull latest commit from git
snowsql -c sfseeurope-demo_mdaeppen -s "$CLONE_SCHEMA_WITH_RELEASE" -q "
  CREATE OR REPLACE SCHEMA $CLONE_DATABASE.$CLONE_SCHEMA_WITH_RELEASE CLONE $SOURCE_DATABASE.$SOURCE_SCHEMA;
"


# deploy release
snowsql -c sfseeurope-demo_mdaeppen -q "
  CREATE OR REPLACE SCHEMA $CLONE_DATABASE.$CLONE_SCHEMA_WITH_RELEASE CLONE $SOURCE_DATABASE.$SOURCE_SCHEMA;
"

# Check result
if [ $? -eq 0 ]; then
  echo "✅ Success! deployment"
else
  echo "❌ An error occurred. Please review the output from SnowSQL above."
  exit 1
fi