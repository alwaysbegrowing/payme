#!/bin/bash

# Set variables for image and container names
IMAGE_NAME="payme_image"
CONTAINER_NAME="payme_container"

# Check if the container is already running, and remove it if it is
if [ $(docker ps -q -f name=^/${CONTAINER_NAME}$) ]; then
  echo "Stopping and removing existing container..."
  docker stop "${CONTAINER_NAME}"
  docker rm "${CONTAINER_NAME}"
  echo "Container removed."
fi

# Build the Docker image
echo "Building Docker image..."
docker build -t "${IMAGE_NAME}" .

# Run the container in detached mode
echo "Running container in detached mode..."
docker run -d --name "${CONTAINER_NAME}" "${IMAGE_NAME}"

echo "Container ${CONTAINER_NAME} is up and running."
