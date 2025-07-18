#!/bin/bash

# Set SonarQube host and token (fallback to placeholder if not set)
SONAR_HOST="${SONAR_HOST:-http://localhost:9000}"
SONAR_TOKEN="${SONAR_TOKEN:-your_token_here}"

# Set export output directory
EXPORT_DIR="./sonarqube_export"
mkdir -p "$EXPORT_DIR"

# Step 1: Fetch all quality profiles
echo "[INFO] Fetching quality profiles..."
profiles=$(curl -s -u "$SONAR_TOKEN:" "$SONAR_HOST/api/qualityprofiles/search")

# Step 2: Parse and export each profile
echo "[INFO] Exporting quality profiles..."
echo "$profiles" | jq -r '.profiles[] | "\(.language) \(.key) \(.name)"' | while read -r lang key name; do
  safe_name=$(echo "$name" | tr ' /' '__')
  filename="$EXPORT_DIR/profile_${safe_name}_${lang}.xml"
  echo "[EXPORT] $name ($lang) -> $filename"

  curl -s -u "$SONAR_TOKEN:" \
       "$SONAR_HOST/api/qualityprofiles/export?profileKey=$key&language=$lang" \
       -o "$filename"
done

echo "[DONE] Exported profiles to: $EXPORT_DIR"

# Step 3: Export custom rules from the 'text' plugin (community plugin 2.0)
echo "[INFO] Exporting custom rules from 'text' plugin..."
CUSTOM_RULES_FILE="$EXPORT_DIR/custom_rules_text.json"

curl -s -u "$SONAR_TOKEN:" \
     "$SONAR_HOST/api/rules/search?languages=txt&ps=500&custom=true" \
     | jq '.' > "$CUSTOM_RULES_FILE"

echo "[EXPORT] Custom Text Rules -> $CUSTOM_RULES_FILE"