#!/bin/bash
source .env

docker exec -it "$AIRFLOW_DOCKER_CONTAINER_NAME" sh -c "airflow connections -a --conn_id $AIRFLOW_SOURCE_CONNECTION_NAME' --conn_uri postgresql://$DB_USER:$DB_PASSWORD@db:5432/$SOURCE_DB_NAME"

docker exec -it "$AIRFLOW_DOCKER_CONTAINER_NAME" sh -c "
airflow connections -a \
    --conn_id '$AIRFLOW_TARGET_CONNECTION_NAME' \
    --conn_type 'postgres' \
    --conn_login '$DB_USER' \
    --conn_password '$DB_PASSWORD' \
    --conn_host 'db2' \
    --conn_port '5432' \
    --conn_schema '$TARGET_DB_NAME'
"