#!/bin/bash

# Set the path to the tips directory
TIPS_DIR="$HOME/tips"

# Get the list of tips files
TIPS_FILES=("$TIPS_DIR"/*.txt)

# Get the number of tips
TIPS_COUNT=${#TIPS_FILES[@]}

# Check if the tips directory exists
if [ ! -d "$TIPS_DIR" ]; then
    echo "Error: The tips directory does not exist."
    exit 1
fi

# Check if there are any tips available
if [ $TIPS_COUNT -eq 0 ]; then
    echo "Error: No tips found in the tips directory."
    exit 1
fi

# Check if the skip file exists
if [ -f "$TIPS_DIR/skip" ]; then
    SKIP=$(cat "$TIPS_DIR/skip")
else
    SKIP=""
fi

# Check if the deactivate file exists
if [ -f "$TIPS_DIR/deactivate" ]; then
    echo "Tip of the day is currently deactivated."
    exit 0
fi

# Get the index of the last shown tip
if [ -f "$TIPS_DIR/index" ]; then
    INDEX=$(cat "$TIPS_DIR/index")
else
    INDEX=0
fi

# Get the next tip index
NEXT_INDEX=$((INDEX + 1))

# Round-robin the tips
if [ $NEXT_INDEX -ge $TIPS_COUNT ]; then
    NEXT_INDEX=0
fi

# Skip tips that have been permanently skipped
while [ "$(basename "${TIPS_FILES[$NEXT_INDEX]}")" == "$SKIP" ]; do
    NEXT_INDEX=$((NEXT_INDEX + 1))

    if [ $NEXT_INDEX -ge $TIPS_COUNT ]; then
        NEXT_INDEX=0
    fi
done

# Show the next tip
echo "Tip of the day:"
cat "${TIPS_FILES[$NEXT_INDEX]}"
echo ""

# Update the index file
echo "$NEXT_INDEX" > "$TIPS_DIR/index"

