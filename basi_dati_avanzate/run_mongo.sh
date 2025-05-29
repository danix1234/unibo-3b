#!/bin/bash

QUERY_FILE="$1"
DB_URL="$2"

function launch_server() {
    if [[ "$(docker ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
        echo "launching the mongo container..." >/dev/tty
        docker run --rm -d -v mongodb_data:/data/db --name mongo-server -p 27017:27017 mongo
        sleep 1
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

case "$*" in
"end" | "stop")
    stop_server
    ;;
"launch" | "run")
    launch_server
    ;;
"show" | "ps")
    docker ps -a
    ;;
"help" | "-h" | "--help" | "")
    echo "Program to launch mongodb server, and run query file on a tracked file

Usage: ./run_mongo.sh [OPTION]|[QUERY_FILE [DB_URL]]

Options:
    end,stop            stop the mongo server
    launch,run          start the mongo server
    show,ps             show running containers
    help,-h,--help      print this help message

Otherwise: 
    (1) QUERY_FILE      file with mongo queries which will be run every time it is saved
    (2) [DB_URL]        url for the server to connect to (if empty: connects to local server)
"
    ;;
*)
    [[ ! -f "$QUERY_FILE" ]] && echo "not a file: $QUERY_FILE" && exit 1
    launch_server
    echo "$QUERY_FILE" | entr sh -c "clear && docker exec -t mongo-server mongosh --quiet $DB_URL --eval \"\$(cat $QUERY_FILE)\""
    ;;
esac
