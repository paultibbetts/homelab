#!/bin/bash

set -e

BACKUP_DIRECTORY="/var/backups/mysql-dumps"
mkdir -p "$BACKUP_DIRECTORY"
cd "$BACKUP_DIRECTORY"

echo "Creating new backup..."
mysqldump --all-databases | gzip > "dump.sql.gz"
echo "Created backup."

echo "Done."

