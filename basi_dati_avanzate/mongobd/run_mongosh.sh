#!/bin/bash

if [[ "$(docker ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
    docker run --rm -d -v mongodb_data:/data/db --name mongo-server -p 27017:27017 mongo
fi &>/dev/null

for _ in {0..3}; do
    docker exec -i mongo-server mongosh "$@" && break
    sleep 0.5
done
