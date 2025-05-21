# connect to testing local mongodb via docker

```sh
docker exec -it "$(docker run --rm -d -v mongodb_data:/data/db  mongo)" bash
```
