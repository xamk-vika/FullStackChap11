#!/bin/bash

# Start Docker Desktop

# Note: must run from deploy folder!
# e.g., sh ./dev/deploydev.sh

# Remove old image and data if necessary
docker compose -p fsrtn-blog -f ./dev/docker-compose.dev.yml down --rmi all
rm -rf ../server/dbdata

# Start the database server
docker compose -p fsrtn-blog -f ./dev/docker-compose.dev.yml up -d --build
