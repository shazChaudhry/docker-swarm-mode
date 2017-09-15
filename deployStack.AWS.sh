#!/bin/bash

alias docker-compose='docker run --interactive --tty --rm --name docker-compose --volume $PWD:/compose --workdir /compose docker/compose:1.16.1'
docker-compose version
docker-compose -f docker-compose.yml -f docker-compose.AWS.yml config > docker-stack.yml
echo "admin" | docker secret create jenkins-user -
echo "admin" | docker secret create jenkins-pass -
docker stack deploy --compose-file docker-stack.yml ci
