#!/bin/bash

set -e

BACKUP_DIRECTORY="/var/backups/postgres-dumps"
mkdir -p "$BACKUP_DIRECTORY"
cd "$BACKUP_DIRECTORY"

echo "Creating new backup..."
sudo -u postgres pg_dumpall > dump.sql
echo "Created backup."

echo "Compressing..."
gzip dump.sql
echo "Compressed."

echo "Done."

