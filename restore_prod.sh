#!/bin/bash
set -e

REMOTE_HOST="35.187.31.97"
REMOTE_USER="axel"
VOLUME="apiday_prod_vol"
DUMP_FILE="/tmp/prod_dump_$(date +%Y%m%d_%H%M%S).dump"

echo "==> Connecting to prod, enter password when prompted..."
pg_dump -h "$REMOTE_HOST" -U "$REMOTE_USER" -d apiday -F c -f "$DUMP_FILE" -W -v --exclude-table=pt1_2024_restore_audit --exclude-table pt1_2024_restore_inserted

TARGET_CONTAINER="apiday"
CLEANUP=false
PORT_ARGS=(-p 5432:5432)
if docker inspect apiday > /dev/null 2>&1; then
  ACTIVE_VOLUME=$(docker inspect --format '{{ range .Mounts }}{{ if eq .Destination "/var/lib/postgresql" }}{{ .Name }}{{ end }}{{ end }}' apiday)
  if [ "$ACTIVE_VOLUME" != "$VOLUME" ]; then
    TARGET_CONTAINER="apiday-restore-tmp"
    CLEANUP=true
    PORT_ARGS=()
  fi
fi

# Remove both possible containers first: either one may still be holding a
# reference to $VOLUME (e.g. left over from a previous run), which would make
# `docker volume rm` below silently no-op instead of actually wiping it.
docker rm -f apiday apiday-restore-tmp > /dev/null 2>&1 || true

# Recreate the volume from scratch instead of `pg_restore --clean`: --clean skips
# tables it can't DROP without CASCADE (e.g. ones referenced by FKs), silently
# leaving stale rows in place instead of the dump's data.
echo "==> Recreating $VOLUME from scratch..."
docker volume rm -f "$VOLUME" > /dev/null 2>&1 || true
docker volume create "$VOLUME" > /dev/null

docker run -d --name "$TARGET_CONTAINER" "${PORT_ARGS[@]}" \
  -e POSTGRES_USER=apiday -e POSTGRES_DB=apiday -e POSTGRES_PASSWORD=apiday \
  -v "$VOLUME:/var/lib/postgresql" \
  postgres:18 > /dev/null

echo "==> Waiting for postgres to be ready..."
until docker exec "$TARGET_CONTAINER" pg_isready -U apiday > /dev/null 2>&1; do
  sleep 1
done

echo "==> Restoring dump..."
docker cp "$DUMP_FILE" "$TARGET_CONTAINER:/tmp/dump.dump"
docker exec "$TARGET_CONTAINER" pg_restore -U apiday -d apiday --no-owner --no-privileges -F c /tmp/dump.dump

if [ "$CLEANUP" = true ]; then
  echo "==> Cleaning up temporary container..."
  docker rm -f "$TARGET_CONTAINER" > /dev/null
fi

echo "==> Cleaning up dump file..."
rm "$DUMP_FILE"

echo "==> Done! ($VOLUME updated, run 'db_use_prod' to switch to it)"
