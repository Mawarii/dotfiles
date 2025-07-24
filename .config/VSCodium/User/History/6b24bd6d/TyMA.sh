#!/bin/env bash

# Catch non-zero exit codes and fail when pipes fail
# unitialized vars also will trigger a fail
set -euo pipefail

#! this sources all common variables
source "${SOURCE_LOCATION}/common"
#! contains all the backup functions
source "${SOURCE_LOCATION}/backup-functions"

# checks some stuff and prints out infos
pre_flight

# switch provider
case $BACKUP_ENVIRONMENT in
    "kubernetes-wsp" )
        source "${SOURCE_LOCATION}/provider/kubernetes-wsp"
        ;;
    "generic-local" )
        source "${SOURCE_LOCATION}/provider/generic-local"
        ;;
    * )
        printf "Unsupported argument %s\n" "$BACKUP_ENVIRONMENT"
        fail "please check your env vars."
        ;;
esac

# dump db / datastore
case $DB_TYPE in
    "postgres" )
        dump_psql
        ;;
    "mariadb" | "mysql" )
        dump_mariadb
        ;;
    "mongodb" )
        dump_mongodb
        ;;
    "pvc" )
        compress_pvc
        ;;
    * )
        printf "Unsupported argument %s\n" "$DB_TYPE"
        fail "please check your env vars."
        ;;
esac

if [ "$ENABLE_LOCAL_BACKUPS" = true ]; then
    printf "Copying to local backup path...\n"

    mkdir -p "$BACKUP_PATH" || fail "couldn't create backup folder. check your permissions."
    cp "$DUMP_DEST" "$BACKUP_PATH/$DUMP_NAME" || fail "check your backup location."
    cp "$DUMP_DEST" "$BACKUP_PATH/latest-backup.sql.gz" || fail "check your backup location."
else
    printf "Uploading to S3 host...\n"

    $MCLI alias set backup $S3_URL $S3_KEY_ID $S3_KEY_SECRET || fail "check your s3 keys"
    $MCLI cp "$DUMP_DEST" "$BACKUP_PATH/$DUMP_NAME" || fail "check your s3 params."
    $MCLI cp "$DUMP_DEST" "$BACKUP_PATH/latest-backup.sql.gz" || fail "check your s3 params."
fi

printf "Success! Backup finished.\n\n"

if [ "$ENABLE_RETENTION" = true ]; then
    printf "Deleting backups older than $RETENTION_DAYS days...\n"

    $MCLI find "$BACKUP_PATH" -type f -name "*.sql.gz" -mtime +$RETENTION_DAYS -exec rm {} \; || fail "couldn't delete old backups. check your permissions."
fi

printf "Success! Old backups deleted.\n"
