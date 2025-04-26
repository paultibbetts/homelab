#!/bin/bash

set -e

cd /var/backups/mysql-dumps

echo "Creating new backup..."
mysqldump --all-databases | gzip > "dump.sql.gz"
echo "Created backup."

echo "Done."

