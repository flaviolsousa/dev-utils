```sh
docker build .
docker build -t $name_of_image .

name_of_image=xxx
docker build -t $name_of_image .
docker run -p 8080:8080 -d $name_of_image

docker run -p 8080:8080 -d $name_of_image && docker logs $(docker ps -lq)

docker ps
docker exec -i -t $id_of_container /bin/bash
```

## Stop / remove all Docker

```sh
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker network prune -f
docker image prune -a -f
docker volume prune -f
```
