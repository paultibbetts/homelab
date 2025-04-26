#!/bin/bash

set -e

echo "Beginning backup..."

cd /var/backups/pi-hole

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
