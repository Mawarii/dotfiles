---
title: Add a custom CA to your Keycloak Docker instance
---

In some cases you want to add a custom CA to your Keycloak instance. To achieve this you'll have to do some tweaks to your compose file.

Following steps have to be taken:

1. Copy provided CA to specific folder
2. Mount the provided CA as volume inside the related Keycloak container
3. Now one have to import the mounted CA into the Keycloak container

!!! Attention
    Password `changeit` is the default for importing certs into Keycloaks keystore.

```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:20.0.5
    restart: unless-stopped
    container_name: keycloak
    volumes:
      - ./imports:/opt/keycloak/data/import
      - /storage:/opt/keycloak/themes/formsflow
      - ./customCA:/opt/keycloak/CustomCA/:Z # bind the files to your container as private and unshared
    entrypoint: []
    command: # run the commands to add the CA as keystore and start keycloak afterwards
      - /bin/sh
      - -c
      - |
        /usr/bin/cp /etc/pki/java/cacerts /opt/keycloak/cacerts
        /usr/bin/chmod 644 /opt/keycloak/cacerts
        /usr/bin/keytool -importcert -alias ucsCA \
          -keystore /opt/keycloak/cacerts -file /opt/keycloak/CustomCA/ca_ldap.cert \
          -storepass changeit -noprompt
        /opt/keycloak/bin/kc.sh start --http-enabled=true --http-port=8080 --hostname-strict=false --hostname-strict-https=false --import-realm 
    environment:
      - KC_DB=postgres
      - KC_DB_URL_HOST=keycloak-db
      - KC_DB_URL_DATABASE=${KEYCLOAK_JDBC_DB:-keycloak}
      - KC_DB_USERNAME=${KEYCLOAK_JDBC_USER:-admin}
      - KC_DB_PASSWORD=${KEYCLOAK_JDBC_PASSWORD:-changeme}
      - KEYCLOAK_ADMIN=${KEYCLOAK_ADMIN_USER:-admin}
      - KEYCLOAK_ADMIN_PASSWORD=${KEYCLOAK_ADMIN_PASSWORD:-changeme}
      - KC_PROXY=edge
      - KC_HTTP_RELATIVE_PATH=/auth
      - KC_SPI_TRUSTSTORE_FILE_FILE=/opt/keycloak/cacerts # CA certs path environment variable
      - KC_SPI_TRUSTSTORE_FILE_PASSWORD=changeit # CA password environment variable
    ports:
      - 8080:8080
    depends_on:
      - keycloak-db
    networks:
      - keycloak-server-network
[...]
```

And thats it. You should be able to use custom CAs with keycloak.
