#!/usr/bin/env bash

CONTAINER_ID=$(docker run --name dsdp -d -p 53/udp carlsverre/damn-simple-dns-proxy)
PROXY_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' $CONTAINER_ID)

_exit() {
    docker kill $CONTAINER_ID >/dev/null
    docker rm $CONTAINER_ID >/dev/null
}
trap _exit EXIT SIGTERM SIGQUIT SIGINT

echo "This should return an answer"
dig @$PROXY_IP +time=1 google.com

echo "This should NOT return an answer"
dig @$PROXY_IP +time=1 not_a_domain
