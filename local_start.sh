#!/bin/bash
set -e

# Load environment variables from .env
if [ ! -f .env ]; then
  echo ".env file not found!"
  exit 1
fi
export $(grep -v '^#' .env | xargs)

# Check required variables
if [ -z "$WIKI_USER" ] || [ -z "$WIKI_PASS" ]; then
  echo "WIKI_USER and WIKI_PASS must be set in .env"
  exit 1
fi

echo "Generating hashed password for Caddy..."
export WIKI_PASS_HASH=$(docker run --rm caddy:2-alpine caddy hash-password --plaintext "$WIKI_PASS")

echo "Stopping any existing containers..."
docker-compose down || true  # ignore errors if not running

echo "Starting Docker Compose stack..."
docker-compose up -d --build

echo "Wiki is now running at http://localhost:8080"
echo "Username: $WIKI_USER"
