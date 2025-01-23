#!/bin/bash

# filename: auto-recorder.sh
# brief: This script takes pictures with the webcam every 15 seconds on startup
# description: On startup, this script takes pictures with the webcam every 15 seconds until the user stops it with auto-recorder.sh stop 
# author: 713koukou-naizaa
# date: 2025-01-21
# usage: starts on startup, stops with auto-recorder.sh stop

# Check if the user wants to stop the script
if [ "$1" == "stop" ]; then
    # Stop the script
    pkill -f auto-recorder.sh
    exit 0
fi

# Start the script
while true; do
    date=$(date +%Y-%m-%d-%H-%M-%S)

    # Take a picture with the webcam
    ffmpeg -f video4linux2 -i /dev/video0 -frames:v 1 output-$date.jpg

    # Wait for 15 seconds
    sleep 15
done