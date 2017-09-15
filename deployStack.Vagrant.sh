#!/bin/bash

docker info
alias docker-compose='docker run --interactive --tty --rm --name docker-compose --volume $PWD:/compose --workdir /compose docker/compose:1.16.1'
docker-compose -f docker-compose.yml config -q
echo "admin" | docker secret create jenkins-user -
echo "admin" | docker secret create jenkins-pass -
docker stack deploy --compose-file docker-compose.yml ci
