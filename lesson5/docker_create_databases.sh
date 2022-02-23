#!/bin/bash
docker exec -it my_postgres_source psql -U root -c "create database my_source_database"
docker exec -it my_postgres_target psql -U root -c "create database my_target_database"