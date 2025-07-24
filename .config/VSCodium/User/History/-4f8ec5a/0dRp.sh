#!/bin/bash
source "${DOCKER_SCRIPTS}"/common.functions
source "${DOCKER_SCRIPTS}"/database.functions
source "${DOCKER_SCRIPTS}"/multitenancy.functions
source "${DOCKER_SCRIPTS}"/keystore.functions

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
