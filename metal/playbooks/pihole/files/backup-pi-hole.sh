#!/bin/bash

set -e

BACKUP_DIR="/var/backups/pi-hole"

echo "Beginning backup..."

mkdir -p $BACKUP_DIR
cd "$BACKUP_DIR" 

PREVIOUS_BACKUP=$(ls -t pi-hole-*.tar.gz 2>/dev/null | head -n 1)		

if [ -n "$PREVIOUS_BACKUP" ]; then
	echo "Deleting previous backup..."
	rm -f $PREVIOUS_BACKUP
	echo "Deleted previous backup."
else		
	echo "No previous backup to delete."
fi

echo "Creating new backup..."
pihole -a -t
echo "Done."
