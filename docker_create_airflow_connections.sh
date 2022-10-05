#!/bin/bash
source .env

docker exec -ti my_container sh -c "echo a && echo b"