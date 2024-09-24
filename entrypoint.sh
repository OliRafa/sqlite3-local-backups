#!/usr/bin/env bash
set -Eeo pipefail

DATABASE_PATH=$1
BACKUPS_FOLDER_PATH=${2:-"/backups"}

if [[ ! -d "$BACKUPS_FOLDER_PATH/daily" \
    || ! -d "$BACKUPS_FOLDER_PATH/last" \
    || ! -d "$BACKUPS_FOLDER_PATH/weekly" \
    || ! -d "$BACKUPS_FOLDER_PATH/monthly" ]]; then
    create-folder-structure $BACKUPS_FOLDER_PATH
fi

exec /usr/local/bin/go-cron -s "$SCHEDULE" -p "$HEALTHCHECK_PORT" $EXTRA_ARGS -- create-backup $DATABASE_PATH $BACKUPS_FOLDER_PATH