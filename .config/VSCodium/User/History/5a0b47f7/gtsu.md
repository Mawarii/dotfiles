---
title: Backup and recover with the CloudNativePG Operator
---

## Backup

To let the operator know where to backup you have to add `.spec.backup` to the database cluster manifest:

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: postgresql-cluster
spec:
  instances: 2
  postgresUID: 10001
  postgresGID: 10001
  storage:
    size: 10Gi
  bootstrap:
    initdb:
      database: yourdatabase
      owner: yourowner
  backup:
    barmanObjectStore:
      destinationPath: "s3://BUCKETNAME/" # Replace BUCKETNAME with the name of your S3 bucket
      endpointURL: https://your-public-s3-address.com
      s3Credentials:
        accessKeyId:
          name: s3-creds # Name of the secret containing the credentials
          key: ACCESS_KEY_ID # Key within the secret for the S3 access key
        secretAccessKey:
          name: s3-creds # Name of the secret containing the credentials
          key: ACCESS_SECRET_KEY # Key within the secret for the S3 secret key
    retentionPolicy: "1d"
```

The Secret could look like this:

```yaml
kind: Secret
apiVersion: v1
metadata:
  name: s3-creds
stringData:
  ACCESS_KEY_ID: "YOUR-KEY-NAME"
  ACCESS_SECRET_KEY: "YOUR-SUPER-SECRET-KEY"
```

This will not trigger any backups yet. Therefore you'll need a `ScheduledBackup`.

!!! warning
    CloudNativePG cron schedules contain 6 digits. The standard cron format has only 5. So be careful because the 1st field represents seconds!

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: ScheduledBackup
metadata:
  name: backup-psql-cluster
spec:
  schedule: "0 0 0 * * *" # Same as standard cron format, but the first field represents seconds. So this backup triggers every day at midnight
  immediate: true # Trigger the first backup immediatly
  backupOwnerReference: none # three possible values: none, self, cluster
  cluster:
    name: postgresql-cluster # Name of the cluster .metadata.name key
```

Important here is the `.spec.backupOwnerReference`. If you set this to `self` or `cluster` all backup resources will be deleted if the owner is deleted. With `none` you have to manually maintain the backup cleanup.

## Recover

As we do not have any logical backups, we will have to do the restore without manually importing any dumps.
There are more ways to restore a cluster, e.g. from an external cluster or from an existing backup inside the same namespace. This documentation will only cover the second one.

So we did a backup from the cluster above and now the cluster is gone. To restore we will have to edit the cluster manifest as follows:

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: postgresql-cluster
spec:
  instances: 2
  postgresUID: 10001
  postgresGID: 10001
  storage:
    size: 10Gi
  bootstrap:
    recovery:
      backup:
        name: backup-psql-cluster-20241224085137
      database: yourdatabase # should be the same as .spec.bootstrap.initdb.database
      owner: yourowner # should be the same as .spec.bootstrap.initdb.owner
```