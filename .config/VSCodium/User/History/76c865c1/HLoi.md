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

2. Execute in the container:

    ```bash
    kubectl exec -it -n your-namespace mariadb-pod-name -- bash
    ```

3. Start a new mysqld session with these settings:

    ```bash
    mysqld --skip-grant-tables --skip-networking --datadir=/bitnami/mariadb/data/
    ```

4. Run a second shell where you execute in the container again and run these commands:

    ```bash
    mariadb -u root
    ```

    ```sql
    USE mysql;
    FLUSH PRIVILEGES;
    ALTER USER 'root'@'%' IDENTIFIED BY 'your_password';
    ```

5. Start the MariaDB pod normally again.

You should be able to login with the new password and everything should work again. If not the problem is way bigger and you have to debug further.
