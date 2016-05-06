Damn Simple DNS Proxy (DSDP)
============================

Created to solve a single problem well.  Run this container in a docker-compose
v2 file and it will proxy dns requests to the docker daemon's embedded dns
server.  Technically this will work for any docker user network, but its
designed to be used with docker-compose.

In the following example, docker-compose spins up redis and DSDP, then connects
to redis from a container using docker's embedded dns server. Then we query DSDP
from the host machine which returns the ip of the redis server as expected.

    .../damn-simple-dns-proxy $ cd example
    .../example $ docker-compose run redis-cli
    Creating network "example_default" with the default driver
    Creating example_redis_1
    Creating example_dns-proxy_1
    redis:6379> set foo bar
    OK
    redis:6379> get foo
    "bar"
    redis:6379>

    .../example $ docker ps
    CONTAINER ID        IMAGE                              COMMAND                  CREATED             STATUS              PORTS                   NAMES
    6877be6c36a0        carlsverre/damn-simple-dns-proxy   "/dsdp"                  22 seconds ago      Up 7 seconds        172.18.0.1:53->53/udp   example_dns-proxy_1
    e18411bfec56        redis                              "docker-entrypoint.sh"   22 seconds ago      Up 7 seconds        6379/tcp                example_redis_1

    .../example $ dig +short @172.18.0.1 redis.docker
    172.18.0.2

If you are on a mac you can forward packets to the new network, and setup your
dns resolver like so:

    .../example $ cat /etc/resolver/docker
    nameserver 172.18.0.1
    domain docker.
    .../example $ sudo route -n add 172.18.0.0/16 $(docker-machine ip)
    add net 172.18.0.0: gateway 192.168.99.100
    .../example $ python -c "import socket; print(socket.gethostbyname('redis.docker'))"
    172.18.0.2
    .../example $ python -c "import redis; print(redis.Redis('redis.docker').get('foo'))"
    bar

Remember to cleanup after playing with the example.  :)

    .../example $ docker-compose down
    Stopping example_dns-proxy_1 ... done
    Stopping example_redis_1 ... done
    Removing example_redis-cli_run_1 ... done
    Removing example_dns-proxy_1 ... done
    Removing example_redis_1 ... done
    Removing network example_default
