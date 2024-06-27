# lnx-folder-bkp

**Very** simple scipt to backup a snapshot of a folder in linux. It retains user permission and ownership. 
Backups are stored in a specified directory, rotated to maintain a specified number of instances, and named according to the date of the backup.

## Features

- Creates compressed backups (`*.tgz`).
- Retains user permissions and ownership.
- Rotates backups to maintain a specified number of instances.
- Supports exclusion of certain directories (`*/@eaDir`, `*/#recycle`, `*/@sharebin`).

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/juehv/lnx-folder-bkp.git
   cd lnx-folder-bkp
   ```

2. **Make the script executable:**

   ```bash
   chmod +x bbackup-folder.sh
   ```

3. **Install required dependencies:**

   - Install rsync and tar on the system.
   - Ensure `pv` (Pipe Viewer) is installed for progress bars during backups.

4. **Adjust configuration:**

   - Modify `SOURCE_DIR`, `SNAPSHOT_DIR`, `BACKUP_DIR`, and `NUM_BACKUPS` variables in `backup-folder.sh` as per your requirements.

## Usage

- Run the script as root:

  ```bash
  sudo ./backup-folder.sh
  ```

- **Automated Backup Setup (Cron Job)**:

  Add the following line to your crontab (`crontab -e`) to run the backup script every Sunday at midnight:

  ```cron
  0 0 * * 0 /path/to/backup-folder.sh
  ```

  This example schedules the script to run every week (`0 0 * * 0`), which means at 00:00 (midnight) on Sunday (`0` represents Sunday in the cron syntax).
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```
