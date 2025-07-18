#!/bin/bash

set -euo pipefail

# Base directories
INFRA_DIR="/Users/mdaeppen/infra"
SONAR_REF_DIR="$INFRA_DIR/sonarqube-ref"
EXPORT_DIR="$SONAR_REF_DIR/data"

# SonarQube data dir (can override via env var)
DATA_DIR="${SONARQUBE_DATA_DIR:-/Users/mdaeppen/infra/sonarqube/data}"
echo "[INFO] Using SonarQube data dir: $DATA_DIR"

# H2 database file
H2_DB_FILE="$DATA_DIR/sonar.mv.db"

# Check if DB exists
if [[ ! -f "$H2_DB_FILE" ]]; then
  echo "❌ H2 database file not found at: $H2_DB_FILE"
  exit 1
fi
echo "[INFO] Found H2 database: $H2_DB_FILE"

# Get current version from SonarQube installation
SONAR_VERSION=$(grep -oP '(?<=<version>).*?(?=</version>)' ../sonarqube/lib/sonar-application-*.jar.manifest 2>/dev/null || echo "unknown")
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE_NAME="sonarqube_h2_backup_${SONAR_VERSION}_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="$EXPORT_DIR/$ARCHIVE_NAME"

echo "[INFO] Creating archive: $ARCHIVE_PATH"
tar -czf "$ARCHIVE_PATH" -C "$DATA_DIR" sonar.mv.db

# Final verification
if [[ -f "$ARCHIVE_PATH" ]]; then
  echo "✅ Exported H2 database to: $ARCHIVE_PATH"
else
  echo "❌ Export failed — archive not created."
  exit 1
fi

# 🔄 Keep only the 10 most recent backup files
echo "[INFO] Cleaning up old backups, keeping the 10 most recent..."
BACKUP_PATTERN="sonarqube_h2_backup_*.tar.gz"
cd "$EXPORT_DIR"
ls -1t $BACKUP_PATTERN 2>/dev/null | tail -n +11 | xargs -r rm -f

echo "✅ Cleanup complete."