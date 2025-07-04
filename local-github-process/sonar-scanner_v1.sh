#!/bin/bash

# Dynamically get the path to this script
#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="/Users/mdaeppen/infra/sonar-scanner"
SONAR_TOKEN="${SONAR_TOKEN:?Missing SONAR_TOKEN}"

PROJECT_KEY="${PROJECT_KEY:?Missing PROJECT_KEY}"
SONAR_HOST="${SONAR_HOST:?Missing SONAR_HOST}"

# Check if the project already exists
echo "Checking if project '$PROJECT_KEY' exists in SonarQube..."
RESPONSE=$(curl -s -u "$SONAR_TOKEN:" "$SONAR_HOST/api/projects/search?projects=$PROJECT_KEY")

if echo "$RESPONSE" | grep -q "\"key\":\"$PROJECT_KEY\""; then
  echo "✅ Project '$PROJECT_KEY' already exists."
else
  echo "➕ Project '$PROJECT_KEY' not found. Creating it..."
  CREATE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -u "$SONAR_TOKEN:" -X POST "$SONAR_HOST/api/projects/create" \
    -d "name=$PROJECT_KEY" \
    -d "project=$PROJECT_KEY")

  if [ "$CREATE_RESPONSE" -eq 200 ]; then
    echo "✅ Successfully created project '$PROJECT_KEY'."
  else
    echo "❌ Failed to create project. HTTP code: $CREATE_RESPONSE"
    exit 1
  fi
fi

# bin/Mother-of-all-Projects.sh
"$SCRIPT_DIR/bin/sonar-scanner" \
 -Dsonar.projectKey=$PROJECT_KEY \
 -Dsonar.projectBaseDir=/Users/mdaeppen/infra/actions-runner/_work/$PROJECT_KEY/$PROJECT_KEY \
 -Dsonar.host.url=$SONAR_HOST \
 -Dsonar.scm.disabled=git \
 -Dsonar.language=sql \
 -Dsonar.sql.dialect=snowflake \
 -Dsonar.token=$SONAR_TOKEN