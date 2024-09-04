#!/bin/bash

# Change to the directory of the script
cd "$(dirname "$0")"

#if docker-compose is runing
ENV=production docker-compose down

# Pull the latest images
ENV=production docker-compose pull

# Run migrations
ENV=production docker-compose run --rm web rails db:create db:migrate

# Seed the database
ENV=production docker-compose run --rm web rails db:seed

# Start the containers in detached mode
ENV=production docker-compose up -d

# Clean up old images
docker image prune -f