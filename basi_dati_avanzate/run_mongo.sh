#!/bin/bash

docker stop mongo-server
docker run --rm -d -v mongodb_data:/data/db --name mongo-server mongo
docker exec -it mongo-server bash
docker stop mongo-server
