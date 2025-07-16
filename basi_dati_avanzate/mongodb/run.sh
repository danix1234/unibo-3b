#!/bin/bash

DB_URL="$1"
mkdir -p /tmp/queries
touch /tmp/queries/mongo.js
podman run --rm -it --security-opt label=type:container_runtime_t -v /tmp/queries:/host:ro --name mongo-client ghcr.io/danix1234/mongo-client sh -c 'mongod --logpath /dev/null & ls /host/mongo.js | entr -c sh -c "mongosh '"$DB_URL"' --quiet --eval \"\$(cat /host/mongo.js)\""'
