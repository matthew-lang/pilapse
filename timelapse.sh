#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "No arguments supplied"
    exit
fi
mkdir -p /home/pi/campi/timelapse/
SLEEP_TIME=$1

if [ "$SLEEP_TIME" -lt "2" ]; then
    echo 'You must enter a number larger than 2 for the sleep time'
    exit
fi
echo "Starting Timelapse sleeping $SLEEP_TIME seconds between snapshots"
mkdir -p /home/pi/timelapse-photos/
sleep 10
while [ 1 ]
do
    DATE=`date +%Y%m%d%H%M%S`
    #echo $DATE Taking Picture
    
    #streamer -f jpeg -o /home/pi/timelapse-photos/${DATE}-photo.jpeg -s 1920x1080 &
    fswebcam -r 1920x1080 --jpeg 100 -D 0 --no-overlay --no-timestamp --no-title --no-underlay --no-banner /home/pi/timelapse-photos/${DATE}-photo.jpg
    sleep $SLEEP_TIME
done

