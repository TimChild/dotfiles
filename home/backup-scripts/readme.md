# Backup Scripts

This directory contains scripts to backup various system and user-specific data.

Note: By default, these scripts will run at login if they have not been run within the last day/week respectively (set in `.profile`)

## Restoring from backup

To restore from the `package_list.txt` run:
```
sudo dpkg --set-selections < packages_list.txt
sudo apt-get dselect-upgrade
```


## Setting up scheduled backups

To schedule the backup scripts to run at specific intervals, we'll be using `cron`.

1. Open the crontab editor:
```bash
crontab -e
```

2. To schedule the `daily-backup.sh` script to run every day at 2 am, add the following line:
```
0 2 * * * /path/to/daily-backup.sh
```

3. To schedule the `weekly-backup.sh` script to run every Sunday at 3 am, add the following line:
``` 
0 3 * * 7 /path/to/weekly-backup.sh
```

4. Save and exit the editor.

5. Ensure both scripts have execute permissions:
```
chmod +x /path/to/daily-backup.sh
chmod +x /path/to/weekly-backup.sh

```


