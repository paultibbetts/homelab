#!/bin/bash

set -e

cd /var/backups/postgres-dumps

echo "Creating new backup..."
sudo -u postgres pg_dumpall > dump.sql
echo "Created backup."

echo "Compressing..."
gzip -f dump.sql
echo "Compressed."

echo "Done."

