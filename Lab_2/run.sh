#!/bin/bash
set -ex

docker volume create shared

NUM_CONTAINERS=$1

for i in $(seq 1 $NUM_CONTAINERS); do
    docker run -d --rm -v shared:/shared concurrent-container
done

echo "$NUM_CONTAINERS containers started successfully."