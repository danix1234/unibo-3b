#!/bin/bash

# notes:
#   - /tmp/query.js is the file to edit to make queries
#   - requires `mongo-client` image from ghcr.io server

touch /tmp/query.js
podman run --rm -it --security-opt label=type:container_runtime_t -v /tmp/query.js:/query.js:ro --name mongo-client ghcr.io/danix1234/mongo-client sh -c 'mongod --logpath /dev/null & ls /query.js | entr -c sh -c "mongosh --quiet --eval \"\$(cat /query.js)\""'
