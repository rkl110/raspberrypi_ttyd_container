#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$SCRIPT_DIR/.env
source "$ENV_FILE"

VOLUME_NAME="data"
CONTAINER_MOUNT_PATH="$DATA_DIR"

# Make sure the volume exists
podman volume exists "$VOLUME_NAME" || podman volume create "$VOLUME_NAME"

while true; do
  echo "Starting new ttyd session container..."
  podman run --rm \
	-p 7681:7681 \
	--env-file="$ENV_FILE" \
	-v "$VOLUME_NAME":"$CONTAINER_MOUNT_PATH" \
	debian-ttyd

  echo "Session ended. Restarting in 3 seconds..."
  sleep 3
done

