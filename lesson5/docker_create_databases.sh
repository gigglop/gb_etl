#!/bin/bash
docker exec -it my_postgres_source psql -U root -c "create database my_source_database"
docker exec -it my_postgres_target psql -U root -c "create database my_target_database"

docker cp tcph/dss.ddl my_postgres_source:/
docker cp tcph/dss.ddl my_postgres_target:/
docker cp tcph/customer.tbl my_postgres_source:/
docker cp tcph/lineitem.tbl my_postgres_source:/
docker cp tcph/nation.tbl my_postgres_source:/
docker cp tcph/orders.tbl my_postgres_source:/
docker cp tcph/part.tbl my_postgres_source:/
docker cp tcph/partsupp.tbl my_postgres_source:/
docker cp tcph/region.tbl my_postgres_source:/
docker cp tcph/supplier.tbl my_postgres_source:/

docker exec -it my_postgres_source psql my_source_database -f dss.ddl
docker exec -it my_postgres_target psql my_target_database -f dss.ddl

docker exec -it my_postgres_source psql my_source_database -c "\copy customer FROM '/customer.tbl' CSV DELIMITER '|'"
docker exec -it my_postgres_source psql my_source_database -c "\copy lineitem FROM '/lineitem.tbl' CSV DELIMITER '|'"
docker exec -it my_postgres_source psql my_source_database -c "\copy nation FROM '/nation.tbl' CSV DELIMITER '|'"
docker exec -it my_postgres_source psql my_source_database -c "\copy orders FROM '/orders.tbl' CSV DELIMITER '|'"
docker exec -it my_postgres_source psql my_source_database -c "\copy part FROM '/part.tbl' CSV DELIMITER '|'"
docker exec -it my_postgres_source psql my_source_database -c "\copy partsupp FROM '/partsupp.tbl' CSV DELIMITER '|'"
docker exec -it my_postgres_source psql my_source_database -c "\copy region FROM '/region.tbl' CSV DELIMITER '|'"
docker exec -it my_postgres_source psql my_source_database -c "\copy supplier FROM '/supplier.tbl' CSV DELIMITER '|'"