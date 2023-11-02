#!/bin/bash

CONTAINER_NAME="db"
DB_USER="your_db_user"
DB_PASSWORD="your_db_password"
DB_NAME="your_db_name"
BACKUP_DIR="/path/to/db/backup/directory"

docker exec $CONTAINER_NAME /usr/bin/mysqldump -u $DB_USER --password=$DB_PASSWORD $DB_NAME > $BACKUP_DIR/backup_$(date +"%Y%m%d").sql
