#!/bin/bash

export SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
export SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
export QUERY_FILE="${SCRIPT_DIR}/queries.js"

echo "${QUERY_FILE}" | entr bash -c "clear; sed '/^[[:space:]]*$/d; /^[[:space:]]*\/\//d' $QUERY_FILE | mongosh --quiet"
