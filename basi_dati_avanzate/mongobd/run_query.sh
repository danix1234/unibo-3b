#!/bin/bash

export SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
export SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
export QUERY_FILE="${SCRIPT_DIR}/queries.js"

echo "${QUERY_FILE}" |
    entr -c bash -c 'mongosh --quiet --eval $(cat $QUERY_FILE | tr -d "\n" )'
