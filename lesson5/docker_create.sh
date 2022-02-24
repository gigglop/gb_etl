#!/bin/bash
source .env

docker volume create --name="$SOURCE_DB_NAME"
docker volume create --name="$TARGET_DB_NAME"
docker-compose up -d
docker ps

# shellcheck disable=SC2046
until nc -z $(docker inspect --format='{{.NetworkSettings.IPAddress}}' "$SOURCE_DB_DOCKER_CONTAINER_NAME") 5432
do
    echo "waiting for postgres container..."
    sleep 0.5
done
docker exec -it "$SOURCE_DB_DOCKER_CONTAINER_NAME" psql -U "$DB_USER" -c "create database $SOURCE_DB_NAME"
# shellcheck disable=SC2046
until nc -z $(docker inspect --format='{{.NetworkSettings.IPAddress}}' "$TARGET_DB_DOCKER_CONTAINER_NAME") 5432
do
    echo "waiting for postgres container..."
    sleep 0.5
done
docker exec -it "$TARGET_DB_DOCKER_CONTAINER_NAME" psql -U "$DB_USER" -c "create database $TARGET_DB_NAME"

docker cp tcph/dss.ddl "$SOURCE_DB_DOCKER_CONTAINER_NAME":/
docker cp tcph/dss.ddl "$TARGET_DB_DOCKER_CONTAINER_NAME":/
docker cp tcph/customer.tbl "$SOURCE_DB_DOCKER_CONTAINER_NAME":/
docker cp tcph/lineitem.tbl "$SOURCE_DB_DOCKER_CONTAINER_NAME":/
docker cp tcph/nation.tbl "$SOURCE_DB_DOCKER_CONTAINER_NAME":/
docker cp tcph/orders.tbl "$SOURCE_DB_DOCKER_CONTAINER_NAME":/
docker cp tcph/part.tbl "$SOURCE_DB_DOCKER_CONTAINER_NAME":/
docker cp tcph/partsupp.tbl "$SOURCE_DB_DOCKER_CONTAINER_NAME":/
docker cp tcph/region.tbl "$SOURCE_DB_DOCKER_CONTAINER_NAME":/
docker cp tcph/supplier.tbl "$SOURCE_DB_DOCKER_CONTAINER_NAME":/

docker exec -it "$SOURCE_DB_DOCKER_CONTAINER_NAME" psql "$SOURCE_DB_NAME" -f dss.ddl
docker exec -it "$TARGET_DB_DOCKER_CONTAINER_NAME" psql "$TARGET_DB_NAME" -f dss.ddl

docker exec -it "$SOURCE_DB_DOCKER_CONTAINER_NAME" psql "$SOURCE_DB_NAME" -c "\copy customer FROM '/customer.tbl' CSV DELIMITER '|'"
docker exec -it "$SOURCE_DB_DOCKER_CONTAINER_NAME" psql "$SOURCE_DB_NAME" -c "\copy lineitem FROM '/lineitem.tbl' CSV DELIMITER '|'"
docker exec -it "$SOURCE_DB_DOCKER_CONTAINER_NAME" psql "$SOURCE_DB_NAME" -c "\copy nation FROM '/nation.tbl' CSV DELIMITER '|'"
docker exec -it "$SOURCE_DB_DOCKER_CONTAINER_NAME" psql "$SOURCE_DB_NAME" -c "\copy orders FROM '/orders.tbl' CSV DELIMITER '|'"
docker exec -it "$SOURCE_DB_DOCKER_CONTAINER_NAME" psql "$SOURCE_DB_NAME" -c "\copy part FROM '/part.tbl' CSV DELIMITER '|'"
docker exec -it "$SOURCE_DB_DOCKER_CONTAINER_NAME" psql "$SOURCE_DB_NAME" -c "\copy partsupp FROM '/partsupp.tbl' CSV DELIMITER '|'"
docker exec -it "$SOURCE_DB_DOCKER_CONTAINER_NAME" psql "$SOURCE_DB_NAME" -c "\copy region FROM '/region.tbl' CSV DELIMITER '|'"
docker exec -it "$SOURCE_DB_DOCKER_CONTAINER_NAME" psql "$SOURCE_DB_NAME" -c "\copy supplier FROM '/supplier.tbl' CSV DELIMITER '|'"