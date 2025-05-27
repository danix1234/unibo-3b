#!/bin/bash

QUERY_FILE="$1"

[[ ! -f "$QUERY_FILE" ]] && echo "not a file: $QUERY_FILE" && exit 1

if [[ "$(docker ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
    docker run --rm -d -v mongodb_data:/data/db --name mongo-server -p 27017:27017 mongo
fi &>/dev/null

echo "${QUERY_FILE}" | entr bash -c "clear; sed '/^[[:space:]]*$/d; /^[[:space:]]*\/\//d' $QUERY_FILE | docker exec -i mongo-server mongosh --quiet"
