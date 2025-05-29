#!/bin/bash

QUERY_FILE="$1"
DB_URL="$2"

function launch_server() {
    if [[ "$(docker ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
        echo "launching the mongo container..." >/dev/tty
        docker run --rm -d -v mongodb_data:/data/db --name mongo-server -p 27017:27017 mongo
    else
        echo "the mongo container is already running!" >/dev/tty
    fi &>/dev/null
}
function stop_server() {
    if [[ "$(docker ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 1 ]]; then
        echo "stopping the mongo container..." >/dev/tty
        docker stop mongo-server
    else
        echo "mongo container is already not running!" >/dev/tty
    fi &>/dev/null
}

case "$QUERY_FILE" in
"end" | "stop")
    stop_server
    exit 0
    ;;
"launch" | "run")
    launch_server
    exit 0
    ;;
esac

[[ ! -f "$QUERY_FILE" ]] && echo "not a file: $QUERY_FILE" && exit 1
launch_server

echo "$QUERY_FILE" | entr sh -c "clear && docker cp $QUERY_FILE mongo-server:/tmp/query.js >/dev/null && docker exec -t mongo-server mongosh --quiet $DB_URL --file /tmp/query.js"
