#!/bin/bash

docker info

docker stack deploy --compose-file docker-compose.yml ci
