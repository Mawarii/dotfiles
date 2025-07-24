#!/bin/bash

echo "-------------- Domibus entry point"

echo "-------------- CATALINA_HOME: ${CATALINA_HOME}"
echo "-------------- DOMIBUS_CONFIG_LOCATION: ${DOMIBUS_CONFIG_LOCATION}"
echo "-------------- DOCKER_DOMINSTALL: ${DOCKER_DOMINSTALL}"
echo "-------------- DOCKER_DOMIBUS_DISTRIBUTION: ${DOCKER_DOMIBUS_DISTRIBUTION}"
echo "-------------- DB_TYPE: ${DB_TYPE}"
echo "-------------- DB_HOST: ${DB_HOST}"
echo "-------------- DB_PORT: ${DB_PORT}"
echo "-------------- DB_NAME: ${DB_NAME}"
echo "-------------- DB_USER: ${DB_USER}"
echo "-------------- DB_PASS: ${DB_PASS}"
echo "-------------- DOMIBUS_VERSION: ${DOMIBUS_VERSION}"
echo "-------------- JACOCO_AGENT: ${JACOCO_AGENT}"
echo "-------------- ENABLE_JACOCO: ${ENABLE_JACOCO}"
echo "-------------- DOCKER_JDBC_DRIVERS: ${DOCKER_JDBC_DRIVERS}"
echo "-------------- MYSQL_JDBC_DRIVER_NAME: ${MYSQL_JDBC_DRIVER_NAME}"
echo "-------------- ORACLE_JDBC_DRIVER_NAME: ${ORACLE_JDBC_DRIVER_NAME}"
echo "-------------- SERVER_DEBUG: ${SERVER_DEBUG}"
echo "-------------- JDK11_RUNTIME: ${JDK11_RUNTIME}"
echo "-------------- LOGGER_LEVEL_ORG_APACHE_CXF: ${LOGGER_LEVEL_ORG_APACHE_CXF}"
echo "-------------- LOGGER_LEVEL_EU_DOMIBUS: ${LOGGER_LEVEL_EU_DOMIBUS}"
echo "-------------- CHECK_DEFAULT_PASSWD: ${CHECK_DEFAULT_PASSWD}"
echo "-------------- DOMAINS_COUNT: ${DOMAINS_COUNT}"
echo "-------------- DOMAIN_ALIASES: ${DOMAIN_ALIASES}"
echo "-------------- DOMIBUS_GENERAL_SCHEMA: ${DOMIBUS_GENERAL_SCHEMA}"
echo "-------------- DOMIBUS_DOMAIN_SCHEMA_PREFIX: ${DOMIBUS_DOMAIN_SCHEMA_PREFIX}"
echo "-------------- DOMIBUS_INIT_PROPERTIES: ${DOMIBUS_INIT_PROPERTIES}"
echo "-------------- DOMIBUS_CONFIG_PROPERTY_FILE: ${DOMIBUS_CONFIG_PROPERTY_FILE}"
echo "-------------- SETUP_MINDER: ${SETUP_MINDER}"
echo "-------------- DATE_MANIPULATION: ${DATE_MANIPULATION}"
echo "-------------- MAXIMUM_WAIT_TIME_IN_SECONDS: ${MAXIMUM_WAIT_TIME_IN_SECONDS}"
echo "-------------- SLEEP_TIME_IN_SECONDS: ${SLEEP_TIME_IN_SECONDS}"
echo "-------------- DEFAULT_USER_AUTOGENERATE_PASSWORD: ${DEFAULT_USER_AUTOGENERATE_PASSWORD}"
echo "-------------- TLS_DAYS_OF_VALIDITY: ${TLS_DAYS_OF_VALIDITY}"

MEMORY_SETTINGS="${MEMORY_SETTINGS:-${MEMORY_SETTING_MIN} ${MEMORY_SETTING_MAX}}"
echo "-------------- MEMORY_SETTING_MIN: ${MEMORY_SETTING_MIN}"
echo "-------------- MEMORY_SETTING_MAX: ${MEMORY_SETTING_MAX}"
echo "-------------- MEMORY_SETTINGS: ${MEMORY_SETTINGS}"

source "${DOCKER_SCRIPTS}"/common.functions
source "${DOCKER_SCRIPTS}"/database.functions
source "${DOCKER_SCRIPTS}"/multitenancy.functions
source "${DOCKER_SCRIPTS}"/keystore.functions

function installDefaultPlugins() {
        createDirectoriesIfMissing "${CATALINA_HOME}"/fs_plugin_data/MAIN
        printf '\nfsplugin.messages.location=%s/fs_plugin_data/MAIN' "${CATALINA_HOME}" >> "${DOMIBUS_CONFIG_LOCATION}"/plugins/config/fs-plugin.properties
}

function buildDomibusStartupParams() {
        echo "buildDomibusStartupParams"

        echo "   DB_TYPE                 : ${DB_TYPE}"
        echo "   DB_HOST                 : ${DB_HOST}"
        echo "   DB_PORT                 : ${DB_PORT}"
        echo "   DB_NAME                 : ${DB_NAME}"
        echo "   DB_USER                 : ${DB_USER}"
        echo "   DB_PASS                 : ${DB_PASS}"

        if [ ! "${CHECK_DEFAULT_PASSWD}" == "" ]; then
                domStartupParams="${domStartupParams} -Ddomibus.passwordPolicy.checkDefaultPassword=${CHECK_DEFAULT_PASSWD}"
        fi

        if [ "${DB_HOST}" ]; then
                domStartupParams="${domStartupParams} -Ddomibus.database.serverName=${DB_HOST}"
        fi

        if [ "${DB_PORT}" ]; then
                domStartupParams="${domStartupParams} -Ddomibus.database.port=${DB_PORT}"
        fi

        if [ "${DB_USER}" ]; then
                domStartupParams="${domStartupParams} -Ddomibus.datasource.user=${DB_USER}"
        fi

        if [ "${DB_PASS}" ]; then
                domStartupParams="${domStartupParams} -Ddomibus.datasource.password=${DB_PASS}"
        fi

        if [ "${CERT_ALIAS}" ]; then
                insertInitProperties "domibus.security.key.private.alias=${CERT_ALIAS}"
                domStartupParams="${domStartupParams} -Ddomibus.security.key.private.alias=${CERT_ALIAS}"
        fi

        if [ "${PRIVATE_PASSWD}" ]; then
                domStartupParams="${domStartupParams} -Ddomibus.security.key.private.password=${PRIVATE_PASSWD}"
        fi

        if [ "${KEYSTORE_PASSWD}" ]; then
                domStartupParams="${domStartupParams} -Ddomibus.security.keystore.password=${KEYSTORE_PASSWD}"
        fi

        if [ "${TRUSTSTORE_PASSWD}" ]; then
                domStartupParams="${domStartupParams} -Ddomibus.security.truststore.password=${TRUSTSTORE_PASSWD}"
        fi

        # Fix the file locking issue due to exposing KahaDB from within the Domibus configuration volume
        domStartupParams="${domStartupParams} -Ddomibus.work.location=${CATALINA_HOME}"

        # Whether to use the default password (i.e. 123456) when creating Domibus users from Tomcat or not
        domStartupParams="${domStartupParams} -Ddomibus.passwordPolicy.defaultUser.autogeneratePassword=${DEFAULT_USER_AUTOGENERATE_PASSWORD}"

        # configure access to the JMS broker
        domStartupParams="${domStartupParams} -DactiveMQ.broker.host=${ACTIVEMQ_HOST}"
        domStartupParams="${domStartupParams} -DactiveMQ.brokerName=${ACTIVEMQ_BROKER_NAME}"
        domStartupParams="${domStartupParams} -DactiveMQ.connectorPort=${ACTIVEMQ_CONNECTOR_PORT}"
        domStartupParams="${domStartupParams} -DactiveMQ.username=${ACTIVEMQ_USERNAME}"
        domStartupParams="${domStartupParams} -DactiveMQ.password=${ACTIVEMQ_PASSWORD}"

#  domStartupParams="${domStartupParams} -Djavax.net.ssl.trustStore=cacerts"
#  domStartupParams="${domStartupParams} -Djavax.net.ssl.trustStorePassword=changeit"
#  domStartupParams="${domStartupParams} -Djavax.net.ssl.trustStoreType=JKS"

        if [ "${ACTIVEMQ_EXTERNAL_BROKER_TYPE}" ]; then
    echo "Disable the use of the activemq.xml configuration file of the local embedded ActiveMQ broker"
    domStartupParams="${domStartupParams} -DactiveMQ.embedded.configurationFile="
  fi

        if [ "${TOMCAT_NODE}" ]; then
                # set the domibus cluster node id (01, 02, ...)
                domStartupParams="${domStartupParams} -Ddomibus.node.id=${TOMCAT_NODE}"

                # copy a Tomcat configuration which runs in cluster mode
          cp -p "${CATALINA_HOME}"/conf/server_clustered.xml "${CATALINA_HOME}"/conf/server.xml

                # make sure quartz scheduler jobs are clustered
                domStartupParams="${domStartupParams} -Ddomibus.deployment.clustered=true"

                # We need an external ActiveMQ broker when running Tomcat as a cluster
                if [ "${ACTIVEMQ_EXTERNAL_BROKER_TYPE}" == "cluster" ]; then
                  # an external cluster of exactly 2 independent brokers

                        # We should use IPs instead of names when registering the ActiveMQ nodes as when an ActiveMQ
                        # node goes down its name/IP ceases to exist on the current Docker network and ActiveMQ client will
                        # produce errors about unresolved node names, whilst if we use the IP the client realizes that the
                        # node is not available but it doesn't produces errors and simply uses the the other node.
#                       ACTIVEMQ_MASTER_NODE_IP=$(dig +short ${ACTIVEMQ_MASTER_NODE} | tail -1)
                        X=0
                        for i in $(echo ${ACTIVEMQ_HOST} | sed "s/,/ /g"); do
                                ((X++))
                                declare ACTIVEMQ_HOST_NODE${X}=${i}
                                declare ACTIVEMQ_HOST_NODE${X}_IP=$(dig +short ${i} | tail -1)
                        done
                        if (( X != 2 )); then
                          echo "We currently only support 2 external independent brokers in a non master-slave cluster setup"
                          exit 1
                        fi
                        domStartupParams="${domStartupParams} -DactiveMQ.transportConnector.uri='failover:(tcp://${ACTIVEMQ_HOST_NODE1_IP}:${ACTIVEMQ_TRANSPORT_CONNECTOR_PORT},tcp://${ACTIVEMQ_HOST_NODE2_IP}:${ACTIVEMQ_TRANSPORT_CONNECTOR_PORT})?maxReconnectDelay=10000&maxReconnectAttempts=5'"
                        domStartupParams="${domStartupParams} -DactiveMQ.JMXURL=service:jmx:rmi:///jndi/rmi://${ACTIVEMQ_HOST_NODE1_IP}:${ACTIVEMQ_CONNECTOR_PORT}/jmxrmi,service:jmx:rmi:///jndi/rmi://${ACTIVEMQ_HOST_NODE2_IP}:${ACTIVEMQ_CONNECTOR_PORT}/jmxrmi"
#                       domStartupParams="${domStartupParams} -DactiveMQ.JMXURL=service:jmx:rmi:///jndi/rmi://${ACTIVEMQ_MASTER_NODE_IP}:${ACTIVEMQ_CONNECTOR_PORT}/jmxrmi"
                elif [ "${ACTIVEMQ_EXTERNAL_BROKER_TYPE}" == "master-slave" ]; then
                  # master-slave external cluster
                        : "${ACTIVEMQ_TRANSPORT_URI:?Need to set ACTIVEMQ_TRANSPORT_URI non-emtpy}"
                        : "${ACTIVEMQ_JMX_URL:?Need to set ACTIVEMQ_JMXURL non-emtpy}"

                        domStartupParams="${domStartupParams} -DactiveMQ.transportConnector.uri='${ACTIVEMQ_TRANSPORT_URI}'"
                        domStartupParams="${domStartupParams} -DactiveMQ.JMXURL=${ACTIVEMQ_JMX_URL}"
                else
                  # external single broker
                        domStartupParams="${domStartupParams} -DactiveMQ.transportConnector.uri=tcp://${ACTIVEMQ_HOST}:${ACTIVEMQ_TRANSPORT_CONNECTOR_PORT}"
                        domStartupParams="${domStartupParams} -DactiveMQ.JMXURL=service:jmx:rmi:///jndi/rmi://${ACTIVEMQ_HOST}:${ACTIVEMQ_CONNECTOR_PORT}/jmxrmi"
                fi
        else
                domStartupParams="${domStartupParams} -DactiveMQ.transportConnector.uri=tcp://${ACTIVEMQ_HOST}:${ACTIVEMQ_TRANSPORT_CONNECTOR_PORT}"
                domStartupParams="${domStartupParams} -DactiveMQ.JMXURL=service:jmx:rmi:///jndi/rmi://${ACTIVEMQ_HOST}:${ACTIVEMQ_CONNECTOR_PORT}/jmxrmi"
        fi

        if isSingleTenancy; then
                if [ "${DB_TYPE}" ]; then
                        case "${DB_TYPE}" in
                        "MySQL")
                                domStartupParams="${domStartupParams} -Ddomibus.datasource.driverClassName=com.mysql.cj.jdbc.Driver"
                                domStartupParams="${domStartupParams} -Ddomibus.datasource.url=\"jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}?useSSL=false&useLegacyDatetimeCode=false&serverTimezone=${DB_MYSQL_TIMEZONE:-UTC}\""
                                ;;
                        "Oracle")
                                domStartupParams="${domStartupParams} -Ddomibus.datasource.driverClassName=oracle.jdbc.OracleDriver"
                                domStartupParams="${domStartupParams} -Ddomibus.datasource.url=jdbc:oracle:thin:@//${DB_HOST}:${DB_PORT}/${DB_NAME}"
                                domStartupParams="${domStartupParams} -Ddomibus.entityManagerFactory.jpaProperty.hibernate.dialect=org.hibernate.dialect.Oracle10gDialect"
                                ;;
                        *)
                                echo "Database Type provided ({$DB_TYPE}) but MUST BE EITHER 'MySQL' or 'Oracle'"
                                exit
                                ;;
                        esac
                fi
        fi

  if [ "${DOMIBUS_CONFIG_PROPERTY_FILE}" == "true" ]; then
    CATALINA_OPTS="${CATALINA_OPTS}"
    # prepend space
    domStartupParams=" ${domStartupParams}"
    # set properties as file init properties
    DOMIBUS_INIT_PROPERTY_DELIMITER=${DOMIBUS_INIT_PROPERTY_DELIMITER:-||}
                insertInitProperties "${domStartupParams// -D/${DOMIBUS_INIT_PROPERTY_DELIMITER}}" "prefix"
  else
      CATALINA_OPTS="${CATALINA_OPTS} ${domStartupParams}"
  fi

  export CATALINA_OPTS="${CATALINA_OPTS} ${MEMORY_SETTINGS}"
  JAVA_OPTS="${SERVER_DEBUG:+-agentlib:jdwp=transport=dt_socket,address=${JDK11_RUNTIME:+*:}8000,server=y,suspend=n} ${JAVA_OPTS} ${SERVER_INIT_PROPERTIES}"
  if [ "x" != "${ENABLE_JACOCO}x" ]; then
          JAVA_OPTS="${JACOCO_AGENT} ${JAVA_OPTS}"
        fi
        export JAVA_OPTS=${JAVA_OPTS}
}

configureMultitenancyDatabaseProperties() {
                if isMultitenancy && [ "${DB_TYPE}" == "MySQL" ]; then
                        echo "Configure multitenancy MySQL database properties"
                        sed -i "s#useSSL=false#useSSL=false\&useLegacyDatetimeCode=false&serverTimezone=${DB_MYSQL_TIMEZONE:-UTC}#g" "${DOMIBUS_CONFIG_LOCATION}"/domibus.properties
                        sed -i "s#pinGlobalTxToPhysicalConnection=true#pinGlobalTxToPhysicalConnection=true\&useLegacyDatetimeCode=false&serverTimezone=${DB_MYSQL_TIMEZONE:-UTC}#g" "${DOMIBUS_CONFIG_LOCATION}"/domibus.properties
                fi
}

function waitForActiveMQ() {
        # There is no point in waiting for an embedded ActiveMQ broker before Tomcat starts since the broker only starts with
        # the Tomcat server itself: we should be only testing for external ActiveMQ brokers below
        if [ "${ACTIVEMQ_EXTERNAL_BROKER_TYPE}" ]; then
                # setting the initial status to an error code
                local ActiveMQCheckStatus=1

                echo "Wait for ActiveMQ nodes to be available"
                if [ "${ACTIVEMQ_EXTERNAL_BROKER_TYPE}" == "cluster" ]; then
                        while [ ${ActiveMQCheckStatus} -ne 0 ]; do
                                        for i in $(echo ${ACTIVEMQ_HOST} | sed "s/,/ /g"); do
                                        ActiveMQCheck=$(dockerize -wait tcp://${i}:${ACTIVEMQ_TRANSPORT_CONNECTOR_PORT} -timeout 5s)
                                        ActiveMQCheckStatus=$(echo $?)
                                        if [ ${ActiveMQCheckStatus} -eq 0 ]; then
                                                echo "Connected to Master at tcp://${i}:${ACTIVEMQ_TRANSPORT_CONNECTOR_PORT}"
#                                               ACTIVEMQ_MASTER_NODE=${i}
                                                break
                                        fi
                                done
                        done
                elif [ "${ACTIVEMQ_EXTERNAL_BROKER_TYPE}" == "master-slave" ]; then
                        while [ ${ActiveMQCheckStatus} -ne 0 ]; do
                                for i in $(echo ${ACTIVEMQ_TRANSPORT_URI} | sed -E 's/.*failover:\((.*)\).*/\1/g' | sed "s/,/ /g"); do
                                        ActiveMQCheck=$(dockerize -wait ${i} -timeout 5s)
                                        ActiveMQCheckStatus=$(echo $?)
                                        if [ ${ActiveMQCheckStatus} -eq 0 ]; then
                                                echo "Connected to Master at ${i}"
                                                break
                                        fi
                                done
                        done
                else
                        while [ ${ActiveMQCheckStatus} -ne 0 ]; do
                                ActiveMQCheck=$(dockerize -wait tcp://${ACTIVEMQ_HOST}:${ACTIVEMQ_TRANSPORT_CONNECTOR_PORT} -timeout 5s)
                                ActiveMQCheckStatus=$(echo $?)
                        done
                fi
                echo
                echo "ActiveMQ started!"
        fi
}

function configureServerHttps() {
  echo "Configuring HTTPS support"

        CERTIFICATES="${CERTIFICATES:-/tmp/}"
        TLS_SERVER_DOMAIN="${TLS_SERVER_DOMAIN:-localhost}"

  [[ ! -d "${DOMIBUS_CONFIG_LOCATION}/keystores" ]] &&  mkdir -p "${DOMIBUS_CONFIG_LOCATION}/keystores"
        cd "${DOMIBUS_CONFIG_LOCATION}"/keystores || exit 13
  generateKeyStore "${TLS_SERVER_DOMAIN}" "test123" "test123" "TLS" "${TLS_DAYS_OF_VALIDITY}"

  sed -i.bak -e "s#</Service>#<Connector port=\"8443\" protocol=\"org.apache.coyote.http11.Http11NioProtocol\" \
maxThreads=\"150\" SSLEnabled=\"true\" scheme=\"https\" secure=\"true\" \
clientAuth=\"false\" sslProtocol=\"TLS\" \
keystoreFile=\"${DOMIBUS_CONFIG_LOCATION}/keystores/TLS-gateway_keystore.jks\" \
keystorePass=\"test123\" \
/></Service>#g" "${CATALINA_HOME}/conf/server.xml"
        diff "${CATALINA_HOME}/conf/server.xml" "${CATALINA_HOME}/conf/server.xml.bak"

#clientAuth=\"true\" ... \
#truststoreFile=\"${DOMIBUS_CONFIG_LOCATION}/keystores/TLS-gateway_truststore.jks\" \
#truststorePass=\"test123\" \
}

# Adapt the Valve localhost_access log to include query string in POST requests to enhance debugging
function configureAccessLogFormat() {
        echo "Configuring Tomcat access log format..."

        sed -i.bak 's|pattern="%h %l %u %t &quot;%r&quot; %s %b"|pattern="%h %l %u %t \&quot;%m %U%q %H\&quot; %s %b"|' "${CATALINA_HOME}/conf/server.xml"
        diff "${CATALINA_HOME}/conf/server.xml" "${CATALINA_HOME}/conf/server.xml.bak"
}

function deployDomibus() {
        echo "Deploying Domibus War..."
        : "${DOMIBUS_VERSION:?Need to set DOMIBUS_VERSION non-empty}"

        unzip "${DOCKER_DOMIBUS_DISTRIBUTION}"/domibus-msh-distribution-"${DOMIBUS_VERSION}"-tomcat-war.zip -d "${CATALINA_HOME}"/webapps
  mv "${CATALINA_HOME}"/webapps/domibus-MSH-tomcat-"${DOMIBUS_VERSION}".war "${CATALINA_HOME}"/webapps/domibus.war
}

##########################################################################
# MAIN PROGRAM STARTS HERE
##########################################################################

cd ~ || exit 13
resetOwnership "edelivery" "edelivery" "edelivery" "${DOMIBUS_CONFIG_LOCATION}"
buildDomibusStartupParams

if [ ! -f ".initialized" ]; then
        echo "Initializing..."
  initializeProxy

        cd "${DOMIBUS_CONFIG_LOCATION}" || exit 13
        if isDomibusConfigured; then
                echo "Domibus is currently being or has already been configured (e.g. by another server instance/tenant)"
        else
                touch "${DOMIBUS_CONFIG_LOCATION}"/.configuring
                prepareDomibusConf "tomcat"
    resetPermissions "edelivery" "g+w" "${DOCKER_DATA}"
                configureLogging
                configureMultitenancy
                configureMultitenancyDatabaseProperties
                configureServerHttps
                configureAccessLogFormat
                findAndReplaceProperties "${DOMIBUS_CONFIG_LOCATION}/domibus.properties"

                # Do a two steps move to avoid any concurrency read-write issues
                touch "${DOMIBUS_CONFIG_LOCATION}"/.configured
                rm "${DOMIBUS_CONFIG_LOCATION}"/.configuring
        fi
        cd - || exit 13
        # finally deploy domibus and install plugins
  deployDomibus
  installDefaultPlugins
  # set status file initialized
        touch ~/.initialized
else
        echo "Resuming..."
fi

waitForActiveMQ
waitForDatabase "${DB_TYPE}" "${DB_HOST}" "${DB_PORT}" "${DB_USER}" "${DB_PASS}" "${DB_NAME}" "${DOMAINS_COUNT}"

echo "Starting Tomcat with: ${CATALINA_OPTS} / ${JAVA_OPTS}"
# Make available to `docker logs` while also adding into catalina.out

if [[ "x${DATE_MANIPULATION}" == "xtrue" ]]; then
  export LD_PRELOAD=/usr/local/lib/faketime/libfaketime.so.1
  #/export FAKETIME=-15d
  export FAKETIME_TIMESTAMP_FILE=/etc/faketime/faketimerc
  export FAKETIME_DONT_FAKE_MONOTONIC=1
fi

"${CATALINA_HOME}"/bin/catalina.sh run -DCATALINA_OPTS="${CATALINA_OPTS}" 2>&1 | tee "${CATALINA_HOME}"/logs/catalina.out
