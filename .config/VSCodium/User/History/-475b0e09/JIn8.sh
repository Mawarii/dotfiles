#!/usr/bin/env bash
# Backing up all formsflow.ai PostgreSQLs and MongoDBs

# Set current timestamp
export BACKUPDATE=$(date +"%Y-%m-%dT%H%M%S-%Z")
echo "-----------------------------------------"
echo "Found databases (postgreSQL and mongoDB):"
echo "-----------------------------------------"
echo

# list all container names build with image including "postgres" or "mongo"
docker ps --format "{{.Image}}: {{.Names}}" | grep -E "postgres|mongo" | awk '{ print $2 }'
echo
echo "=> Backup results:"
echo "------------------"
echo

# run loop to backup postgreSQL and mongoDB using their ENV variables
for LINE in $(docker ps --format "{{.Image}}: {{.Names}}" | grep -E "postgres|mongo" | awk '{ print $2 }'); do
  if docker inspect --format="{{.Config.Image}}" $LINE | grep postgres
  then
    echo "$LINE"_$BACKUPDATE.dump && \
    docker exec -i "$LINE" sh -c 'PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB"' > "$LINE"_"$BACKUPDATE".dump
  else
    echo "$LINE"_"$BACKUPDATE".dump && \
    docker exec -i "$LINE" sh -c 'mongodump --username="$MONGO_INITDB_ROOT_USERNAME" --password="$MONGO_INITDB_ROOT_PASSWORD" -d "$MONGO_INITDB_DATABASE" --authenticationDatabase="$MONGO_INITDB_ROOT_USERNAME" --archive="/tmp/backupscript_mongo.dump" --gzip' && \
    docker cp "$LINE":/tmp/backupscript_mongo.dump ./"$LINE"_"$BACKUPDATE".dump && \
    docker exec -i "$LINE" sh -c 'rm /tmp/backupscript_mongo.dump'
  fi
done
