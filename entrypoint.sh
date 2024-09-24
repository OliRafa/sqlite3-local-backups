#!/usr/bin/env bash
set -Eeo pipefail

DATABASE_PATH=$1
BACKUPS_FOLDER_PATH=${2:-"/backups"}
BACKUP_KEEP_DAYS=${3:-7}
BACKUP_KEEP_WEEKS=${4:-4}
BACKUP_KEEP_MONTHS=${5:-6}
BACKUP_KEEP_MINS=${6:-1440}

if [[ ! -d "$BACKUPS_FOLDER_PATH/daily" \
    || ! -d "$BACKUPS_FOLDER_PATH/last" \
    || ! -d "$BACKUPS_FOLDER_PATH/weekly" \
    || ! -d "$BACKUPS_FOLDER_PATH/monthly" ]]; then
    create-folder-structure $BACKUPS_FOLDER_PATH
fi

exec /usr/local/bin/go-cron -s "$SCHEDULE" -p "$HEALTHCHECK_PORT" $EXTRA_ARGS -- create-backup $DATABASE_PATH $BACKUPS_FOLDER_PATH \
&& delete-old-backups $BACKUPS_FOLDER_PATH $BACKUP_KEEP_MINS $BACKUP_KEEP_DAYS $BACKUP_KEEP_WEEKS $BACKUP_KEEP_MONTHS