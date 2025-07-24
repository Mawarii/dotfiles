---
title: Add a custom CA to your Keycloak Docker instance
---

In some cases you want to add a custom CA to your Keycloak instance. To achieve this you'll have to do some steps. This guide is related to a compose deployment but should be pretty easy to convert to any other kind of deployment.

Fist of all you should have a `compose.yaml` file like this one:

```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:20.0.5
    restart: unless-stopped
    container_name: keycloak
    volumes:
      - ./imports:/opt/keycloak/data/import
      - /storage:/opt/keycloak/themes/formsflow
    entrypoint: []
    command: /opt/keycloak/bin/kc.sh start --http-enabled=true --http-port=8080 --hostname-strict=false --hostname-strict-https=false --import-realm 
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
[...]
```

Now we will add the custom CA files to the container and tell keycloak to use it. (Note every line with comments.):

```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:20.0.5
    restart: unless-stopped
    container_name: keycloak
    volumes:
      - ./imports:/opt/keycloak/data/import
      - /storage:/opt/keycloak/themes/formsflow
      - ./customCA:/opt/keycloak/CustomCA/:Z # "The Z option indicates that the bind mount content is private and unshared."
    entrypoint: []
    command: # run the commands to add the CA as keystore
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
      - KC_SPI_TRUSTSTORE_FILE_FILE=/opt/keycloak/cacerts # CA certs path
      - KC_SPI_TRUSTSTORE_FILE_PASSWORD=changeit # CA password
    ports:
      - 8080:8080
    depends_on:
      - keycloak-db
    networks:
      - keycloak-server-network
[...]
```

And thats it. You should now be able to use custom CAs with keycloak.
