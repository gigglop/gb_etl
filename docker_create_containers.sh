#!/bin/bash
source .env
# shellcheck disable=SC2155
export FERNET_KEY=$(python3 -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)")

docker volume create --name=$SOURCE_DB_NAME
docker volume create --name=$TARGET_DB_NAME
docker compose up -d

unset FERNET_KEY