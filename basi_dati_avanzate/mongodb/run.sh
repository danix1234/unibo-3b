#!/bin/bash

# notes:
#   - /tmp/query.js is the file to edit to make queries 
#   - requires `mongo-client` image from ghcr.io
#
# paramters:
#   - kill|stop|rm  -> stop container
#   - restart       -> restart container

if [[ "$1" =~ kill|stop|rm|restart ]]; then
    podman kill mongo-client &>/dev/null && echo "container removed"
    [[ "$1" =~ kill|stop|rm ]] && exit 0
fi

if ! podman container inspect -f '{{.State.Running}}' mongo-client &>/dev/null; then
    touch /tmp/query.js
    podman run --rm -d --security-opt label=type:container_runtime_t -v /tmp/query.js:/query.js:ro --name mongo-client ghcr.io/danix1234/mongo-client >/dev/null && echo "container launched"
fi

podman exec -it mongo-client sh -c 'ls /query.js | entr -c sh -c "mongosh --quiet --eval \"\$(cat /query.js)\""'
