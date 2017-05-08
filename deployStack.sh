#!/bin/bash
docker-compose pull
docker stack deploy -c docker-compose.yml ci
