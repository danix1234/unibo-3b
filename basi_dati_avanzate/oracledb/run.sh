#!/bin/bash

DB_URL="$1"
[[ -z "$DB_URL" ]] && echo 'missing url for oracle connection' && exit 1
mkdir -p /tmp/queries
touch /tmp/queries/oracle.sql
podman run --rm -it --security-opt label=type:container_runtime_t -v /tmp/queries:/host:ro ghcr.io/danix1234/oracle-client sh -c 'ls /host/oracle.sql | entr -c sh -c "echo \"\$(cat /host/oracle.sql)\" | sqlplus -s '"$DB_URL"'"'
