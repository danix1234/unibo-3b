#!/bin/bash

# notes:
#   - /tmp/query.sql is the file to edit to make queries
#   - requires `oracle-client` image, built from dockerfile

touch /tmp/query.sql
podman run --rm -it --security-opt label=type:container_runtime_t -v /tmp/query.sql:/query.sql:ro localhost/oracle-client sh -c 'ls /query.sql | entr sh -c ""'
