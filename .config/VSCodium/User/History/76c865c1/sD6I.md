---
title: "How to fix `Access denied for user 'root'@'localhost' (using password: YES)` Error for Bitnami's MariaDB Container"
---

If you get this error your authentication table is most likely corrupted. This can be easily fixed.

1. Remove both `readinessProbe` and `livenessProbe`:

    ```yaml
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
      name: mariadb
    template:
      metadata:
      annotations:
            checksum/configuration: c8fdbdda7720abaf213457ccf43ad940cf7924c41aaa505a6021f657a0f99652
        creationTimestamp: null
        labels:
            app.kubernetes.io/component: primary
            app.kubernetes.io/instance: mariadb
            app.kubernetes.io/managed-by: Helm
            app.kubernetes.io/name: mariadb
            helm.sh/chart: mariadb-12.2.5
        spec:
        affinity:
            podAntiAffinity:
            preferredDuringSchedulingIgnoredDuringExecution:
                - podAffinityTerm:
                    labelSelector:
                    matchLabels:
                        app.kubernetes.io/component: primary
                        app.kubernetes.io/instance: mariadb
                        app.kubernetes.io/name: mariadb
                    topologyKey: kubernetes.io/hostname
                weight: 1
        containers:
    readinessProbe: null
    livenessProbe: null
    ```

2. Start the mariadb container with a `sleep infinity` command:

    ```yaml
    command: ["sleep", "infinity"]
    ```

3. Execute into the container:

    ```bash
    kubectl exec -it -n your-namespace mariadb-pod-name -- bash
    ```

4. Start a new mysqld session with these settings:

    ```bash
    mysqld --skip-grant-tables --skip-networking --datadir=/bitnami/mariadb/data/
    ```

5. Start a second shell where you execute into the container and run these commands:

    ```bash
    mariadb -u root
    ```

    ```sql
    USE mariadb;
    FLUSH PRIVILEGES;
    ALTER USER 'root'@'%' IDENTIFIED BY 'your_password';
    ```

6. Remove the sleep command and enable `readinessProbe` and `livenessProbe` again.
