#!/bin/bash

cd /path/to/your/application

# Pull the latest images
docker-compose pull

# Run migrations
docker-compose run --rm web rails db:create db:migrate

# Seed the database
docker-compose run --rm web rails db:seed

# Start the containers in detached mode
docker-compose up -d
