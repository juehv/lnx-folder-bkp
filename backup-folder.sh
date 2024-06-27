#!/bin/bash

# Configuration
SOURCE_DIR="/home/" # use / at the end
BACKUP_DIR="/mnt/backup" # do NOT use / at the end
SNAPSHOT_DIR="/tmp/snapshot" # do NOT use / at the end
BACKUP_FILENAME="backup-opt" # do NOT add ending 

# Function to check if pv is installed
check_pv() {
    if ! command -v pv >/dev/null 2>&1; then
        echo "Error: pv (Pipe Viewer) is not installed."
        echo "Please install pv to display progress bars."
        echo "(e.g. apt install pv)"
        exit 1
    fi
}

# Check if pv is installed
check_pv

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Date format for the backup filename
DATE=$(date +"%Y-%m-%d")

# Backup filename
BACKUP_FILE="${BACKUP_DIR}/${DATE}-${BACKUP_FILENAME}.tgz"

# Number of backups to retain
NUM_BACKUPS=10

# Create snapshot using rsync with progress
echo "Creating snapshot with rsync..."
rsync -a --delete --info=progress2 "${SOURCE_DIR}/" "${SNAPSHOT_DIR}/"

# Create tarball from snapshot with progress
echo "Creating tarball from snapshot..."
tar -cf - -C "${SNAPSHOT_DIR}" . | pv -s $(du -sb "${SNAPSHOT_DIR}" | awk '{print $1}') | gzip > "${BACKUP_FILE}"

# Remove snapshot
rm -rf "${SNAPSHOT_DIR}"

# Rotate backups
cd "${BACKUP_DIR}"
if [ $(ls -1 | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}-${BACKUP_FILENAME}\.tgz$' | wc -l) -ge ${NUM_BACKUPS} ]; then
    # Find and remove the oldest backup file
    OLDEST_BACKUP=$(ls -1tr | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}-${BACKUP_FILENAME}\.tgz$' | head -n 1)
    rm -f "${OLDEST_BACKUP}"
fi
