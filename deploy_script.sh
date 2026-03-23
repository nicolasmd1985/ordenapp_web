#!/bin/bash
set -e
cd "$(dirname "$0")"

WEB_CONTAINER_NAME="ordenapp_web_container"
TEMP_CONTAINER_NAME="temp_asset_compiler"
NGINX_USER="www-data"

echo "Ensuring Docker network exists..."
docker network inspect app_network >/dev/null 2>&1 || docker network create app_network

echo "Bringing down existing services and removing old containers..."
docker stop $WEB_CONTAINER_NAME || true
docker rm -f $WEB_CONTAINER_NAME || true
docker rm -f $TEMP_CONTAINER_NAME || true
ENV=production docker-compose down --remove-orphans --volumes

echo "Pulling the latest image for web service..."
ENV=production docker-compose pull web

echo "Running database migrations and seeds..."
ENV=production docker-compose run --rm web bundle exec rails db:prepare db:seed

echo "Preparing public directory..."
sudo mkdir -p /home/ubuntu/deploy/public/
sudo rm -rf /home/ubuntu/deploy/public/*

echo "Creating temporary container for asset compilation..."
docker create --name $TEMP_CONTAINER_NAME nicolasmd/ordenappweb:latest

echo "Clearing old assets..."
docker start $TEMP_CONTAINER_NAME
docker exec $TEMP_CONTAINER_NAME bundle exec rake assets:clobber

echo "Precompiling assets..."
docker exec $TEMP_CONTAINER_NAME bundle exec rake assets:precompile

echo "Copying assets from temporary container..."
sudo docker cp "${TEMP_CONTAINER_NAME}:/app/public/ordenapp/assets" "/home/ubuntu/deploy/public/"

echo "Verifying asset copy..."
ASSET_COUNT=$(find /home/ubuntu/deploy/public/assets -type f | wc -l)
if [ "$ASSET_COUNT" -lt 10 ]; then
    echo "Error: Very few assets were copied. Expected more than 10 files."
    echo "Current asset count: $ASSET_COUNT"
    echo "Checking temporary container's public directory..."
    docker exec $TEMP_CONTAINER_NAME ls -la /app/public/ordenapp/assets
    echo "Checking host's public directory..."
    ls -la /home/ubuntu/deploy/public/assets
    exit 1
fi

echo "Cleaning up temporary container..."
docker stop $TEMP_CONTAINER_NAME
docker rm $TEMP_CONTAINER_NAME

echo "Starting the main containers in detached mode..."
ENV=production docker-compose up -d --remove-orphans

echo "Waiting for '$WEB_CONTAINER_NAME' to be fully up..."
sleep 15

if ! docker ps -q -f name="^/${WEB_CONTAINER_NAME}$"; then
    echo "Error: Container $WEB_CONTAINER_NAME is not running. Check logs above."
    ENV=production docker-compose logs web
    exit 1
fi

echo "Setting permissions for deployed assets..."
sudo chown -R ubuntu:ubuntu /home/ubuntu/deploy/public
sudo find /home/ubuntu/deploy/public -type d -exec chmod 755 {} \;
sudo find /home/ubuntu/deploy/public -type f -exec chmod 644 {} \;
sudo chmod 755 /home/ubuntu/deploy

echo "Cleaning up old Docker images..."
docker image prune -af

echo "Deployment finished successfully."
echo "Total assets copied: $ASSET_COUNT"

# echo "Verifying Rails config..."
# docker exec -it $WEB_CONTAINER_NAME rails c
# docker exec -it $WEB_CONTAINER_NAME puts Rails.application.config.relative_url_root