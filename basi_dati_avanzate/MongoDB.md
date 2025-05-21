# connect to testing local mongodb via docker

```sh
DOCKER_ID="$(docker run --rm -d -v mongodb_data:/data/db --name mongo-server mongo)" &&
docker exec -it "$DOCKER_ID" bash
```
