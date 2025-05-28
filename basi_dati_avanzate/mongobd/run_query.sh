#!/bin/bash

QUERY_FILE="$1"
DB_URL="$2"

[[ ! -f "$QUERY_FILE" ]] && echo "not a file: $QUERY_FILE" && exit 1

echo "$QUERY_FILE" | entr -c mongosh --quiet "$DB_URL" --file "$QUERY_FILE"
