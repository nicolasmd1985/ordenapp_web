#!/bin/bash
set -e
cd "$(dirname "$0")"

WEB_CONTAINER_NAME="ordenapp_web_container"
NGINX_USER="www-data"

echo "Ensuring Docker network exists..."
docker network inspect app_network >/dev/null 2>&1 || docker network create app_network

echo "Bringing down existing services and removing old containers..."
docker stop $WEB_CONTAINER_NAME || true
docker rm -f $WEB_CONTAINER_NAME || true
ENV=production docker-compose down --remove-orphans --volumes

echo "Pulling the latest image for web service..."
ENV=production docker-compose pull web

echo "Running database migrations..."
ENV=production docker-compose run --rm web bundle exec rails db:prepare

echo "Clearing old assets..."
ENV=production docker-compose run --rm web bundle exec rake assets:clobber

echo "Precompiling assets..."
ENV=production docker-compose run --rm web bundle exec rake assets:precompile

echo "Starting the containers in detached mode..."
ENV=production docker-compose up -d --remove-orphans

echo "Waiting for '$WEB_CONTAINER_NAME' to be fully up..."
sleep 15

if ! docker ps -q -f name="^/${WEB_CONTAINER_NAME}$"; then
    echo "Error: Container $WEB_CONTAINER_NAME is not running. Check logs above."
    ENV=production docker-compose logs web
    exit 1
fi

echo "Copying assets from '$WEB_CONTAINER_NAME' container to the host..."
sudo mkdir -p /home/ubuntu/deploy/public/
sudo rm -rf /home/ubuntu/deploy/public/*

echo "Copying /app/public/. from container $WEB_CONTAINER_NAME to /home/ubuntu/deploy/public/"
sudo docker cp "${WEB_CONTAINER_NAME}:/app/public/." "/home/ubuntu/deploy/public/"

echo "Setting permissions for deployed assets..."
sudo chown -R ubuntu:ubuntu /home/ubuntu/deploy/public # Keep ubuntu:ubuntu
sudo find /home/ubuntu/deploy/public -type d -exec chmod 755 {} \; # rwxr-xr-x for 'others'
sudo find /home/ubuntu/deploy/public -type f -exec chmod 644 {} \; # rw-r--r-- for 'others'
sudo chmod 755 /home/ubuntu/deploy # Ensure parent is traversable by 'others'

echo "Cleaning up old Docker images..."
docker image prune -af

echo "Deployment finished."

echo "Verifying Rails config..."
docker exec -it $WEB_CONTAINER_NAME rails c
docker exec -it $WEB_CONTAINER_NAME puts Rails.application.config.relative_url_root