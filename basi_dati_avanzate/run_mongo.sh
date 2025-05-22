#!/bin/bash

docker stop mongo-server
docker run --rm -d -v mongodb_data:/data/db --name mongo-server -p 27017:27017 mongo
docker exec -it mongo-server bash
