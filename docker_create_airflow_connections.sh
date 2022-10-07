#!/bin/bash
source .env

docker exec -it "$AIRFLOW_DOCKER_CONTAINER_NAME" sh -c "
airflow connections add '$SOURCE_DB_NAME' \
    --conn-type 'Postgres' \
    --conn-login '$DB_USER' \
    --conn-password '$DB_PASSWORD' \
    --conn-host 'db' \
    --conn-port '5432' \
    --conn-schema '$SOURCE_DB_NAME'
"
docker exec -it "$AIRFLOW_DOCKER_CONTAINER_NAME" sh -c "
airflow connections add '$TARGET_DB_NAME' \
    --conn-type 'Postgres' \
    --conn-login '$DB_USER' \
    --conn-password '$DB_PASSWORD' \
    --conn-host 'db2' \
    --conn-port '5432' \
    --conn-schema '$TARGET_DB_NAME'
"