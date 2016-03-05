#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "No arguments supplied"
    exit
fi

SLEEP_TIME=$1

if [ "$SLEEP_TIME" -lt "2" ]; then
    echo 'You must enter a number larger than 2 for the sleep time'
    exit
fi

OUTPUT_DIR=/home/pi/timelapse-photos
INSTALL_LOC=/home/pi/timelapse-pi
ZIP_DIR=/home/pi/timelapse-zips

function takePicture(){
    NUM_FILES=$(printf "%06d" $(ls -1 /home/pi/timelapse-photos/ | wc -l))
    PIC_NAME=${OUTPUT_DIR}/${NUM_FILES}-photo.jpg
    #streamer -f jpeg -o /home/pi/timelapse-photos/${NUM_FILES}-photo.jpeg -s 1920x1080 &
    fswebcam -r 1920x1080 --jpeg 100 -D 0 --no-overlay --no-timestamp --no-title --no-underlay --no-banner ${PIC_NAME}
    zip -j -g ${ZIP_NAME} ${PIC_NAME}
}

function createEmptyZip(){
    NUM_ZIPS=$(printf "%06d" $(ls -1 $ZIP_DIR | wc -l))
    ZIP_NAME=${ZIP_DIR}/zip-${NUM_ZIPS}.zip
    cp ${INSTALL_LOC}/empty.zip ${ZIP_NAME}
}
echo "Starting Timelapse sleeping $SLEEP_TIME seconds between snapshots"

#mkdir if not exists
mkdir -p /home/pi/timelapse-photos/
mkdir -p ${ZIP_DIR}

#delete all 0b files... have to move this
#find /home/pi/timelapse-photos/ -name "*.jpg" -size 0b -delete

rm -rf $OUTPUT_DIR/*
createEmptyZip

sleep 1
while [ 1 ]
do
    takePicture &
    sleep $SLEEP_TIME
done

