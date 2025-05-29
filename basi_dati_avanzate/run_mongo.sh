#!/bin/bash

QUERY_FILE="$1"

function launch_server() {
    if [[ "$(podman ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
        if [[ $1 == "show" ]]; then
            echo "launching the mongo container [WARNING: MONGO PORT SHOWN ON LOCALHOST!]..." >/dev/tty
            podman run --rm -d -v mongodb_data:/data/db --name mongo-server -p27017:27017 docker.io/library/mongo:latest
        else
            echo "launching the mongo container..." >/dev/tty
            podman run --rm -d -v mongodb_data:/data/db --name mongo-server --network none docker.io/library/mongo:latest
        fi
        sleep 1
    fi &>/dev/null
}
function stop_server() {
    if [[ "$(podman ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 1 ]]; then
        echo "stopping the mongo container..." >/dev/tty
        podman stop mongo-server
    fi &>/dev/null
}

case "$1" in
"end" | "stop")
    stop_server
    ;;
"launch" | "run")
    launch_server "$2"
    ;;
"relaunch" | "restart")
    stop_server
    launch_server "$2"
    ;;
"show" | "ps")
    podman ps -a
    ;;
"help" | "-h" | "--help" | "")
    echo "Program to launch mongodb server, and run query file on a tracked file

Usage: ./run_mongo.sh [OPTION]|[QUERY_FILE [DB_URL]]

Options:
    end,stop            stop the mongo server
    launch,run          start the mongo server
    relaunch,restart    restart the mongo server
    show,ps             show running containers
    help,-h,--help      print this help message

Extra Options (launch,run,relaunch,restart):
    show                make mongo server port available for everyone       

Otherwise: 
    (1) QUERY_FILE      file with mongo queries which will be run every time it is saved
    (2) [DB_URL]        url for the server to connect to (if empty: connects to local server)
"
    ;;
*)
    [[ ! -f "$QUERY_FILE" ]] && echo "not a file: $QUERY_FILE" && exit 1
    launch_server
    echo "$QUERY_FILE" | entr sh -c "clear && podman exec -t mongo-server mongosh --quiet --eval \"\$(cat $QUERY_FILE)\""
    ;;
esac
