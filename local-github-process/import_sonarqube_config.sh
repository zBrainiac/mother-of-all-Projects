#!/bin/bash

# Configuration
SONAR_HOST="${SONAR_HOST:-http://localhost:9000}"
SONAR_TOKEN="${SONAR_TOKEN:-your_token_here}"
IMPORT_DIR="./sonarqube_export"

# Check for dependencies
command -v jq >/dev/null 2>&1 || { echo >&2 "jq is required but not installed."; exit 1; }

# Step 1: Import quality profiles
echo "[INFO] Importing quality profiles from $IMPORT_DIR..."

find "$IMPORT_DIR" -name "profile_*.xml" | while read -r profile_file; do
  echo "[IMPORT] $profile_file"
  curl -s -u "$SONAR_TOKEN:" -X POST "$SONAR_HOST/api/qualityprofiles/restore" \
    -F "backup=@$profile_file" > /dev/null
done

echo "[DONE] Quality profiles import complete."

# Step 2: Import custom 'text' rules (if supported by plugin)
CUSTOM_RULES_FILE="$IMPORT_DIR/custom_rules_text.json"

if [[ -f "$CUSTOM_RULES_FILE" ]]; then
  echo "[INFO] Importing custom text rules..."

  rules_count=$(jq '.total' "$CUSTOM_RULES_FILE")
  echo "[INFO] Found $rules_count custom text rules to import."

  jq -c '.rules[]' "$CUSTOM_RULES_FILE" | while read -r rule; do
    name=$(echo "$rule" | jq -r '.name')
    key=$(echo "$rule" | jq -r '.key')
    markdown_desc=$(echo "$rule" | jq -r '.htmlDesc' | sed 's/<[^>]*>//g')
    severity=$(echo "$rule" | jq -r '.severity')
    status=$(echo "$rule" | jq -r '.status')

    # Assuming manual recreation of custom rules (API limitations)
    echo "[SKIP] Cannot import rule '$name' (key: $key) automatically — no official API support."
    # You could optionally recreate via the UI or store manually
  done
else
  echo "[INFO] No custom rules JSON found. Skipping custom rule import."
fi

echo "[DONE] Import script completed."
