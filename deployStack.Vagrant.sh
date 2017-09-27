#!/bin/bash

docker info
echo "admin" | docker secret create jenkins-user -
echo "admin" | docker secret create jenkins-pass -
docker stack deploy --compose-file docker-compose.yml ci
