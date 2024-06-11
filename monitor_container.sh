#!/bin/bash

# Configuration
CONTAINER_NAME="springboot-app"
IMAGE_NAME="samuel007/crud:latest"
THRESHOLD_MB=500  # Define your size threshold in MB

# Function to get container size
get_container_size() {
  CONTAINER_ID=$(docker ps -q -f name=$CONTAINER_NAME)
  if [ -z "$CONTAINER_ID" ]; then
    echo "Container $CONTAINER_NAME is not running."
    return 1
  fi

  CONTAINER_SIZE=$(docker system df -v | grep $CONTAINER_ID | awk '{print $4}' | grep -o '[0-9]\+')
  echo $CONTAINER_SIZE
}

# Function to start a new container with a larger size
start_new_container() {
  NEW_SIZE=$((CONTAINER_SIZE * 2))
  echo "Starting a new container with size $NEW_SIZE MB."

  # Stop the current container
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME

  # Start a new container with the same image and a larger size
  docker run -d --name $CONTAINER_NAME -e SIZE=$NEW_SIZE $IMAGE_NAME
}

# Main script
while true; do
  CONTAINER_SIZE=$(get_container_size)
  if [ $? -eq 0 ]; then
    if [ "$CONTAINER_SIZE" -gt "$THRESHOLD_MB" ]; then
      echo "Container size $CONTAINER_SIZE MB exceeds the threshold of $THRESHOLD_MB MB."
      start_new_container
    else
      echo "Container size $CONTAINER_SIZE MB is within the threshold."
    fi
  else
    echo "Skipping size check since the container is not running."
  fi

  # Sleep for a while before checking again
  sleep 60
done
