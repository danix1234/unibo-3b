#!/bin/bash

# notes:
#   - /tmp/query.sql is the file to edit to make queries
#   - requires `oracle-client` image from ghcr.io server

DB_URL="$1"
touch /tmp/query.sql
podman run --rm -it --security-opt label=type:container_runtime_t -v /tmp/query.sql:/query.sql:ro ghcr.io/danix1234/oracle-client sh -c 'ls /query.sql | entr -c sh -c "echo \"\$(cat /query.sql)\" | sqlplus -s '"$DB_URL"'"'
