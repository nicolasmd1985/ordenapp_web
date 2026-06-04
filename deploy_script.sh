#!/bin/bash
set -e
cd "$(dirname "$0")"

# Set environment
export ENV=production

WEB_CONTAINER_NAME="ordenapp_web_container"
TEMP_CONTAINER_NAME="temp_asset_compiler"
DEPLOY_DIR="$HOME/ordenapp"

echo "Ensuring Docker network exists..."
docker network inspect app_network >/dev/null 2>&1 || docker network create app_network

echo "Bringing down existing services and removing old containers..."
docker stop $WEB_CONTAINER_NAME || true
docker rm -f $WEB_CONTAINER_NAME || true
docker rm -f $TEMP_CONTAINER_NAME || true
docker compose down --remove-orphans

echo "Pulling the latest image for web service..."
docker compose pull web

echo "Running database migrations and seeds..."
docker compose run --rm web bundle exec rails db:prepare db:seed

echo "Preparing public directory..."
mkdir -p "$DEPLOY_DIR/public/"
rm -rf "$DEPLOY_DIR/public/"*

echo "Creating temporary container to extract precompiled assets..."
docker create --name $TEMP_CONTAINER_NAME nicolasmd/ordenappweb:latest

echo "Copying assets from temporary container..."
docker cp "${TEMP_CONTAINER_NAME}:/app/public/ordenapp/assets" "$DEPLOY_DIR/public/"

echo "Verifying asset copy..."
ASSET_COUNT=$(find "$DEPLOY_DIR/public/assets" -type f | wc -l || echo 0)
if [ "$ASSET_COUNT" -lt 10 ]; then
    echo "Error: Very few assets were copied. Expected more than 10 files."
    echo "Current asset count: $ASSET_COUNT"
    echo "Checking host's public directory..."
    ls -la "$DEPLOY_DIR/public/assets" || true
    exit 1
fi

echo "Cleaning up temporary container..."
docker rm $TEMP_CONTAINER_NAME || true

echo "Starting the main containers in detached mode..."
docker compose up -d --remove-orphans

echo "Waiting for '$WEB_CONTAINER_NAME' to be fully up..."
sleep 15

if ! docker ps -q -f name="^/${WEB_CONTAINER_NAME}$"; then
    echo "Error: Container $WEB_CONTAINER_NAME is not running. Check logs above."
    docker compose logs web
    exit 1
fi

echo "Setting permissions for deployed assets..."
sudo chown -R $(whoami):$(whoami) "$DEPLOY_DIR/public" || chown -R $(whoami):$(whoami) "$DEPLOY_DIR/public" || true
sudo find "$DEPLOY_DIR/public" -type d -exec chmod 755 {} \; || find "$DEPLOY_DIR/public" -type d -exec chmod 755 {} \; || true
sudo find "$DEPLOY_DIR/public" -type f -exec chmod 644 {} \; || find "$DEPLOY_DIR/public" -type f -exec chmod 644 {} \; || true
sudo chmod 755 "$DEPLOY_DIR" || chmod 755 "$DEPLOY_DIR" || true

echo "Cleaning up old Docker images..."
docker image prune -af

echo "Deployment finished successfully."
echo "Total assets copied: $ASSET_COUNT"