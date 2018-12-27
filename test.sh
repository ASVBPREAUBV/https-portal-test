#!/usr/bin/env bash

git pull

docker rm $(docker ps -a -q) -f

echo "container removed"

docker run \
-l traefik.frontend.rule=Host:whoami.docker.localhost \
containous/whoami

echo "whoami running"

docker run \
-p 9000:80 \
-d \
--net fastnetwork \
-l traefik.docker.network=fastnetwork \
-l traefik.enable=true \
-l traefik.frontend.entryPoints=http \
-l traefik.basic.frontend.rule=Host:pfaulk.de \
-l traefik.basic.port=9000 \
-l traefik.basic.protocol=http \
--name html \
nginx

echo "nginx running"

docker run \
-p 8080:8080 \
-p 80:80 \
-p 443:443 \
-v $PWD/traefik.toml:/etc/traefik/traefik.toml \
-v /var/run/docker.sock:/var/run/docker.sock \
--net fastnetwork \
traefik


# -d
# -v $PWD/acme.json:/acme.json

