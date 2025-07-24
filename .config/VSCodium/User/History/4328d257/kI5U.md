---
title: Add a custom CA to your Keycloak Docker instance
---

In some cases you want to add a custom CA to your Keycloak instance. To achieve this you'll have to do some steps. This guide is related to a compose deployment but should be pretty easy to convert to any other kind of deployment.

Fist of all you should have some compose.yaml file like this one:

```yaml
  keycloak:
    image: quay.io/keycloak/keycloak:20.0.5
    restart: unless-stopped
    container_name: forms-flow-idm-keycloak
    volumes:
      - ./imports:/opt/keycloak/data/import
      - /storage/main-instance/docker-data/forms-flow-idm-keycloak/themes:/opt/keycloak/themes/formsflow
      - ./CustomCA:/opt/keycloak/CustomCA/:Z
    entrypoint: []
    command:
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
      - KC_SPI_TRUSTSTORE_FILE_FILE=/opt/keycloak/cacerts
      - KC_SPI_TRUSTSTORE_FILE_PASSWORD=changeit
    ports:
      - 8080:8080
    depends_on:
      - keycloak-db
    networks:
      - keycloak-server-network
```
