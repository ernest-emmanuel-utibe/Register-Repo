#!/bin/bash

# Define threshold (e.g., 80%)
THRESHOLD=80
CONTAINER_NAME=dev_tools_container

# Function to get the current disk usage
get_disk_usage() {
  docker exec $CONTAINER_NAME df / | awk 'NR==2 {print $5}' | sed 's/%//'
}

# Function to increase disk space (example, actual implementation may vary)
increase_disk_space() {
  NEW_SIZE=$((CURRENT_SIZE + 10))
  docker run --storage-opt size=${NEW_SIZE}G -d -p 9200:9200 -p 9000:9000 -p 3000:3000 -p 9090:9090 --name new_dev_tools_container my_dev_tools
}

# Monitor disk space
while true; do
  CURRENT_USAGE=$(get_disk_usage)
  if [ "$CURRENT_USAGE" -ge "$THRESHOLD" ]; then
    echo "Disk usage is above threshold. Current usage: $CURRENT_USAGE%"
    increase_disk_space
    echo "Increased disk space and started a new container."
    break
  fi
  sleep 60
done
