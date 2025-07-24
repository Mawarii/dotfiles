# Backup Scripts for WSP databases

## Supported DBs

* Postgres
* MariaDB
* MySQL
* MongoDB
* PVC (Yeah, we know. This is no DB.)

## Disabling backups in your Cronjob with kustomize
*⚠ This is only available in versions **>=v1.3.0**. So update your images if needed. ⚠*

If you want to disable the backups, you need to set the variable **`YES_I_DONT_NEED_BACKUPS_AND_DOCUMENTED_THIS_SOMEWHERE`** to the value  *UNDERSTOOD*

You can do this with kustomize and add this snippet to the patches section. The `cronjob-backup.patch.yaml` template file can be found [here](./examples/cronjob-backup.patch.yaml). Please edit the file and copy it into your project folder.

```yaml
patches:
  [...]
  - path: cronjob-backup.patch.yaml
    target:
      kind: CronJob
      name: cronjob-<database>-backup # Replace `<database>` with your database name. Possible values: mariadb, mongodb, mysql, postgresql`
```

## How to use

Following Variables can or have to be set in order for the backup scripts to work

```sh
## Declaring ENV
# Database
DB_TYPE=${DB_TYPE:-"postgres"} # postgres / mariadb / mysql / mongodb / pvc
DB_USER=${DB_USER:-"postgres"}
DB_PASSWORD=${DB_PASSWORD:-"password"}
DB_PORT=${DB_PORT:-"5432"}
DB_HOST=${DB_HOST:-"localhost"}
# DB_DATABASE=${DB_DATABASE:-"postgres"}

# PVC
PVC_DATA_LOCATION=${PVC_DATA_LOCATION:-"/data"}

# S3 params
BUILD_URL="${CLUSTER_STAGE_S3_URL_PROTOCOL}://${CLUSTER_STAGE_S3_URL}"
S3_URL=${BUILD_URL:-"http://s3.local"} #this is unecessary, leaving this for now
S3_KEY_ID=${CLUSTER_STAGE_S3_ACCESS_KEY:-"backupkey"}
S3_KEY_SECRET=${CLUSTER_STAGE_S3_SECRET_KEY:-"supersecret"}
S3_BUCKET_NAME=${CLUSTER_STAGE_S3_BUCKET_NAME_BACKUP:-"backup"}
# folder in which to put the dump on S3 backend
S3_BUCKET_SUBDIR=${BUCKET_SUBDIR:-"default"}
```
