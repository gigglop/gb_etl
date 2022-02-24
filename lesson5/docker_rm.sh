#!/bin/bash
source .env
docker-compose down
# shellcheck disable=SC2046
docker rm -f $(docker ps -q -f name="$SOURCE_DB_DOCKER_CONTAINER_NAME" && docker ps -q -f name="$TARGET_DB_DOCKER_CONTAINER_NAME")
# shellcheck disable=SC2046
docker volume rm $(docker volume ls -q -f name="$SOURCE_DB_NAME" && docker volume ls -q -f name="$TARGET_DB_NAME")