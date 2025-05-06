#!/bin/bash
set -e
cd "$(dirname "$0")"

WEB_CONTAINER_NAME="ordenapp_web_container" # Matches container_name in docker-compose.yml
NGINX_USER="www-data" # Or "nginx" - CHECK THIS ON YOUR SERVER

echo "Bringing down existing services..."
ENV=production docker-compose down --remove-orphans

echo "Pulling the latest image for web service..."
ENV=production docker-compose pull web # Only pull the web service image

echo "Running database migrations..."
ENV=production docker-compose run --rm web bundle exec rails db:create
ENV=production docker-compose run --rm web bundle exec rails db:migrate

echo "Starting the containers in detached mode..."
ENV=production docker-compose up -d

echo "Waiting for container to be fully up..."
sleep 10 # Give the container a moment to start properly

echo "Copying assets from '$WEB_CONTAINER_NAME' container to the host..."
sudo mkdir -p /home/ubuntu/deploy/public/
sudo rm -rf /home/ubuntu/deploy/public/* # Clean the entire public directory on host

echo "Copying /app/public/. from container $WEB_CONTAINER_NAME to /home/ubuntu/deploy/public/"
sudo docker cp "${WEB_CONTAINER_NAME}:/app/public/." "/home/ubuntu/deploy/public/"

echo "Setting permissions for deployed assets..."
sudo chown -R ubuntu:${NGINX_USER} /home/ubuntu/deploy/public
sudo chmod -R u+rwX,g+rX,o-rwx /home/ubuntu/deploy/public # Owner: rwx, Group: rx, Other: ---
# Ensure parent dirs allow Nginx group to traverse
sudo chgrp ${NGINX_USER} /home/ubuntu/deploy
sudo chmod g+x /home/ubuntu/deploy

echo "Cleaning up old Docker images..."
docker image prune -af

echo "Deployment finished."