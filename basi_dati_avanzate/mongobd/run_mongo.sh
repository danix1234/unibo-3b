#!/bin/bash

QUERY_FILE="$1"
DB_URL="$2"

if [[ "$(docker ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
    echo "launching mongo server in a docker container..." >/dev/tty
    docker run --rm -d -v mongodb_data:/data/db --name mongo-server -p 27017:27017 mongo
fi &>/dev/null

[[ -z "$QUERY_FILE" ]] && exit 0
[[ ! -f "$QUERY_FILE" ]] && echo "not a file: $QUERY_FILE" && exit 1

echo "$QUERY_FILE" | entr sh -c "clear && docker cp $QUERY_FILE mongo-server:/tmp/query.js >/dev/null && mongosh --quiet $DB_URL --file /tmp/query.js"
