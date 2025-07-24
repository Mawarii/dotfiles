#!/usr/bin/env bash

read -p "Choose your path to store the dumps [$(pwd)]: " dumpPath
dumpPath=${dumpPath:-$(pwd)}

currentDate=$(date '+%Y-%m-%d')

for container in `docker ps --format json | jq -r '.ID'`;
do
    image=$(docker inspect "$container" | jq -r '.[].Config.Image')
    serviceName=$(docker inspect "$container" | jq -r '.[].Config.Labels.["com.docker.compose.service"]' | sed 's/forms-flow-//')
    printf "Dumping $serviceName...\n"

    if [[ $image =~ "mongo" ]]; then
        docker exec -i "$container" /bin/bash -c 'mongodump -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD -d $MONGO_INITDB_DATABASE --archive="/tmp/formio.dump.gz" --gzip --authenticationDatabase=admin'
        docker cp -q "$container":/tmp/formio.dump.gz "$dumpPath"/"$currentDate"-"$serviceName".dump.gz

    elif [[ $image =~ "postgres" ]]; then
        docker exec -i "$container" /bin/bash -c 'PGPASSWORD=$POSTGRES_PASSWORD pg_dump -w -U $POSTGRES_USER -d $POSTGRES_DB --clean' > "$dumpPath"/"$currentDate"-"$serviceName".dump

    fi
done
