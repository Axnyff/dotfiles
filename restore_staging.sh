#!/bin/bash
set -e

DUMP_FILE="/tmp/staging_dump_$(date +%Y%m%d_%H%M%S).dump"

echo "==> Downloading dump from staging..."
pg_dump -h 34.77.120.149 -U axel -d apiday -F c -f "$DUMP_FILE"

echo "==> Resetting local Docker postgres..."
docker rm -f $(docker ps -a -q) 2>/dev/null || true
docker run -p 5432:5432 --name apiday -e POSTGRES_USER=apiday -e POSTGRES_DB=apiday -e POSTGRES_PASSWORD=apiday -d postgres

echo "==> Waiting for postgres to be ready..."
until docker exec apiday pg_isready -U apiday > /dev/null 2>&1; do
  sleep 1
done

echo "==> Restoring dump to local DB..."
pg_restore -h localhost -U apiday -d apiday --no-owner --no-privileges -F c "$DUMP_FILE"

echo "==> Cleaning up..."
rm "$DUMP_FILE"

echo "==> Done!"
