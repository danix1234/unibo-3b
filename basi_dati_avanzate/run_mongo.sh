#!/bin/bash

if command -v jq &>/dev/null; then
    if ! docker ps --format '{{json .}}' | jq -e -s 'any(.[]; .Names == "mongo-server")' >/dev/null; then
        docker run --rm -d -v mongodb_data:/data/db --name mongo-server -p 27017:27017 mongo
    fi
else
    docker stop mongo-server
    docker run --rm -d -v mongodb_data:/data/db --name mongo-server -p 27017:27017 mongo
fi

docker exec -it mongo-server bash
