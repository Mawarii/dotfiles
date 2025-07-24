---
title: "How to fix `Access denied for user 'root'@'localhost' (using password: YES)` Error for Bitnami's MariaDB Container"
---

If you get this error your authentication table is most likely corrupted. This can be easily fixed.

1. Remove both `readinessProbe` and `livenessProbe` and start the container with a `sleep infinity` command:

    ```yaml
    apiVersion: apps/v1
    kind: StatefulSet
    spec:
      template:
        spec:
          containers:
            - name: mariadb
              ...
              command: ["sleep", "infinity"]
              ...
              readinessProbe: null
              livenessProbe: null
              ...
    ```

3. Execute in the container:

    ```bash
    kubectl exec -it -n your-namespace mariadb-pod-name -- bash
    ```

4. Start a new mysqld session with these settings:

    ```bash
    mysqld --skip-grant-tables --skip-networking --datadir=/bitnami/mariadb/data/
    ```

5. Run a second shell where you execute in the container again and run these commands:

    ```bash
    mariadb -u root
    ```

    ```sql
    USE mysql;
    FLUSH PRIVILEGES;
    ALTER USER 'root'@'%' IDENTIFIED BY 'your_password';
    ```

6. Start the MariaDB pod normally again.
