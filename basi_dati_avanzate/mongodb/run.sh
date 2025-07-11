#!/bin/bash

# notes:
# - /tmp/query.js is the file to edit to make queries (do not delete!)
# - requires `mongo-client` image, built from dockerfile

if [[ "$1" =~ kill|stop|rm ]]; then
    podman kill mongo-client &>/dev/null && echo "container removed"
    exit 0
fi

if ! podman container inspect -f '{{.State.Running}}' mongo-client &>/dev/null; then
    touch /tmp/query.js
    podman run --rm -d --security-opt label=type:container_runtime_t -v /tmp/query.js:/query.js:ro --name mongo-client localhost/mongo-client >/dev/null && echo "container launched"
fi
