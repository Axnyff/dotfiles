#!/bin/bash
set -e

REMOTE_HOST="35.187.31.97"
REMOTE_USER="axel"
VOLUME="apiday_prod_vol"
DUMP_FILE="/tmp/prod_dump_$(date +%Y%m%d_%H%M%S).dump"

echo "==> Downloading dump from prod..."
pg_dump -h "$REMOTE_HOST" -U "$REMOTE_USER" -d apiday -F c -f "$DUMP_FILE" -W --exclude-table=pt1_2024_restore_audit --exclude-table pt1_2024_restore_inserted

docker volume create "$VOLUME" > /dev/null

TARGET_CONTAINER="apiday"
CLEANUP=false
ACTIVE_VOLUME=""
if docker inspect apiday > /dev/null 2>&1; then
  ACTIVE_VOLUME=$(docker inspect --format '{{ range .Mounts }}{{ if eq .Destination "/var/lib/postgresql" }}{{ .Name }}{{ end }}{{ end }}' apiday)
fi

if [ "$ACTIVE_VOLUME" != "$VOLUME" ]; then
  echo "==> 'apiday' container is not on $VOLUME, using a temporary container..."
  TARGET_CONTAINER="apiday-restore-tmp"
  docker rm -f "$TARGET_CONTAINER" > /dev/null 2>&1 || true
  docker run -d --name "$TARGET_CONTAINER" \
    -e POSTGRES_USER=apiday -e POSTGRES_DB=apiday -e POSTGRES_PASSWORD=apiday \
    -v "$VOLUME:/var/lib/postgresql" \
    postgres:18 > /dev/null
  CLEANUP=true
else
  echo "==> 'apiday' container is already on $VOLUME, restoring in place..."
fi

echo "==> Waiting for postgres to be ready..."
until docker exec "$TARGET_CONTAINER" pg_isready -U apiday > /dev/null 2>&1; do
  sleep 1
done

echo "==> Restoring dump..."
docker cp "$DUMP_FILE" "$TARGET_CONTAINER:/tmp/dump.dump"
docker exec "$TARGET_CONTAINER" pg_restore -U apiday -d apiday --clean --if-exists --no-owner --no-privileges -F c /tmp/dump.dump

if [ "$CLEANUP" = true ]; then
  echo "==> Cleaning up temporary container..."
  docker rm -f "$TARGET_CONTAINER" > /dev/null
fi

echo "==> Cleaning up dump file..."
rm "$DUMP_FILE"

echo "==> Done! ($VOLUME updated, run 'db_use_prod' to switch to it)"
