---
title: Backup and restore with the CloudNativePG Operator
---

### Backup

To create a backup you have to add `.spec.backup` to the database cluster manifest:

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
