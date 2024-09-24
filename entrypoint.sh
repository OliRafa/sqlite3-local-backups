#!/usr/bin/env bash
set -Eeo pipefail

DATABASE_PATH=$1
BACKUPS_FOLDER_PATH=${2:-"/backups"}
SCHEDULE=${3:-"@daily"}
BACKUP_KEEP_MINS=${4:-1440}
BACKUP_KEEP_DAYS=${5:-7}
BACKUP_KEEP_WEEKS=${6:-4}
BACKUP_KEEP_MONTHS=${7:-6}
HEALTHCHECK_PORT=${8:-8080}
BACKUP_ON_START=${9:-"FALSE"}

if [[ ! -d "$BACKUPS_FOLDER_PATH/daily" \
    || ! -d "$BACKUPS_FOLDER_PATH/last" \
    || ! -d "$BACKUPS_FOLDER_PATH/weekly" \
    || ! -d "$BACKUPS_FOLDER_PATH/monthly" ]]; then
    create-folder-structure $BACKUPS_FOLDER_PATH
fi

EXTRA_ARGS=""
# Initial background backup
if [ "${BACKUP_ON_START}" = "TRUE" ]; then
  EXTRA_ARGS="-i"
fi

exec /usr/local/bin/go-cron -s "$SCHEDULE" -p "$HEALTHCHECK_PORT" $EXTRA_ARGS -- /bin/bash -c "create-backup $DATABASE_PATH $BACKUPS_FOLDER_PATH \
    && delete-old-backups $BACKUPS_FOLDER_PATH $BACKUP_KEEP_MINS $BACKUP_KEEP_DAYS $BACKUP_KEEP_WEEKS $BACKUP_KEEP_MONTHS"