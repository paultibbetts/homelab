#!/bin/bash

set -e

cd /var/backups/gitea

PREVIOUS_BACKUP=$(ls -t *.zip 2>/dev/null | head -n 1)		

if [ -n "$PREVIOUS_BACKUP" ]; then
	echo "Deleting previous backup..."
	sudo -u git rm -f $PREVIOUS_BACKUP
	echo "Deleted previous backup."
else		
	echo "No previous backup to delete."
fi

echo "Creating backup..."
sudo -u git /home/gitea/bin/gitea dump
echo "Created backup."

echo "Done."
