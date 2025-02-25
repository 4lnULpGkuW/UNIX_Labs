#!/bin/sh

SHARED_DIR="/shared"

LOCK_FILE="$SHARED_DIR/lock"

CONTAINER_ID=$(cat /proc/sys/kernel/random/uuid)
COUNTER=0

echo "Container started with ID: $CONTAINER_ID"

while true; do
    COUNTER=$((COUNTER + 1))

    exec 3>"$LOCK_FILE"
    flock 3

    for i in $(seq -f "%03g" 1 999); do
        FILE="$SHARED_DIR/$i"
        if [ ! -e "$FILE" ]; then
            echo "$CONTAINER_ID" > "$FILE"
            echo "$COUNTER" >> "$FILE"
            FILE_NAME="$FILE"
            break
        fi
    done

    exec 3<&-

    if [ -z "$FILE_NAME" ]; then
        echo "No available filenames. Waiting..."
        sleep 1
        continue
    fi

    echo "Created: $FILE_NAME"
    sleep 1

    rm -f "$FILE_NAME"
    echo "Deleted: $FILE_NAME"
    sleep 1
done
