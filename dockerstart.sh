#!/bin/bash

# Set variables for image and container names
IMAGE_NAME="payme_image"
CONTAINER_NAME="payme_container"

# Function to check if a docker container exists
container_exists() {
  docker ps -a -q -f name=^/${CONTAINER_NAME}$
}

# Function to check if a docker container is running
container_is_running() {
  docker ps -q -f name=^/${CONTAINER_NAME}$
}

# Stop and remove container if it is running
if container_is_running; then
  echo "Stopping and removing existing container..."
  docker stop "${CONTAINER_NAME}"
  docker rm "${CONTAINER_NAME}"
  echo "Container removed."
elif container_exists; then
  # Remove container if it exists but is not running
  echo "Removing existing container..."
  docker rm "${CONTAINER_NAME}"
  echo "Container removed."
fi

# Build the Docker image
echo "Building Docker image..."
docker build -t "${IMAGE_NAME}" .

# Run the container in detached mode
# Mount the entire project directory as a volume
echo "Running container in detached mode..."
docker run -d -p 8501:8501 \
  -v $(pwd):/home/projects/payme \
  --name "${CONTAINER_NAME}" \
  "${IMAGE_NAME}"

echo "Container ${CONTAINER_NAME} is up and running."
