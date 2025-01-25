# auto-recorder

## Overview
`auto-recorder.sh` is a script taking photos via the webcam and screenshots every 15 seconds before sending them by email. The script also collects geolocation, IP address, WiFi SSID, and MAC address information. It is made to run in background on startup to monitor the computer in cas of theft.

## Features
- Takes a photo every 15 seconds with `ffmpeg`.
- Takes a screenshot every 15 seconds with `flameshot`.
- Collects geolocation, IP address, WiFi SSID, and MAC address.
- Sends the photos, screenshots and other information via email.

## Installation
1. Ensure these packages are installed:
   - `ffmpeg`
   - `flameshot` (you should disable all GUI notifications for the script to run silently)
   - `mutt` (must be configured)
   - `curl`
   - `iputils`
   - `iw`

2. Clone the repository:
   ```bash
   git clone https://github.com/713koukou-naizaa/auto-recorder.git
   cd auto-recorder

3. Make the script executable:
   ```bash
   chmod +x auto-recorder.sh

4. Make the script run on startup depending on your system