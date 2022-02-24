#!/bin/bash

docker volume create --name="$SOURCE_DB_NAME"
docker volume create --name="$TARGET_DB_NAME"
docker-compose up -d