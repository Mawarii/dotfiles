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
    "local" )
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

printf "Saving dumps to backup location...\n"

$MCLI cp "$DUMP_DEST" "$BACKUP_PATH/$DUMP_NAME" || fail "check your permissions."
$MCLI cp "$DUMP_DEST" "$BACKUP_PATH/latest-backup.sql.gz" || fail "check your permissions."

printf "Success! Backup finished.\n\n"

if [ "$ENABLE_RETENTION" = true ]; then
    printf "Deleting backups older than $RETENTION_DAYS days...\n"

    $MCLI find "$BACKUP_PATH" -name "*.sql.gz" --older-than +$RETENTION_DAYS -exec "$MCLI rm {}" || fail "couldn't delete old backups. check your permissions."
fi

printf "Success! Old backups deleted.\n"
