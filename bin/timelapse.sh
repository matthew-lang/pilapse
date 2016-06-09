#!/bin/bash

echo "Staring PiLapse"

if [[ $# -eq 0 ]]; then
    echo "No arguments supplied"
    exit
fi

SLEEP_TIME=$1

if [ "$SLEEP_TIME" -lt "2" ]; then
    echo 'You must enter a number larger than 2 for the sleep time'
    exit
fi
echo "Sleeping for ${SLEEP_TIME} between shots"

BASE_DIR=/home/pi/pilapse
OUTPUT_DIR="${BASE_DIR}/timelapse-photos"
INSTALL_LOC="${BASE_DIR}/bin"
ZIP_DIR="${BASE_DIR}/timelapse-zips"

function takePicture(){
    [ -e /dev/video0 ] || exit
    echo "Taking Picture"
    NUM_FILES=$(printf "%06d" $(ls -1 ${OUTPUT_DIR} | wc -l))
    PIC_NAME=${OUTPUT_DIR}/${NUM_FILES}-photo.jpg
    #streamer -f jpeg -o /home/pi/timelapse-photos/${NUM_FILES}-photo.jpeg -s 1920x1080 &
    fswebcam -r 1920x1080 --jpeg 100 -D 0 --quiet --no-overlay --no-timestamp --no-title --no-underlay --no-banner ${PIC_NAME} || echo "unable to take photo"
    echo "Saved."
    #zip picture
    #[ -s $PIC_NAME ] && zip -j -g ${ZIP_NAME} ${PIC_NAME}
}
function copyLastSession(){
    NUM_FILES=$(printf "%06d" $(ls -1 ${OUTPUT_DIR} | wc -l))
    echo "Found ${NUM_FILES} that need to be zipped from previous session"
    if (( $NUM_FILES < 1 )); then
        echo "No previous session data found."
        return 1
    fi
    find ${OUTPUT_DIR} -name "*.jpg" -size 0b -delete
    TEMP_DIR="${BASE_DIR}/.tmp"
    mv ${OUTPUT_DIR} ${TEMP_DIR}
    zipTemp &
}
function zipTemp(){
   echo ${TEMP_DIR}
   NUM_ZIPS=$(printf "%06d" $(ls -1 $ZIP_DIR | wc -l))
   ZIP_NAME=${ZIP_DIR}/zip-${NUM_ZIPS}.zip
   zip -j ${ZIP_NAME} ${TEMP_DIR}/*
   rm -rf ${TEMP_DIR}
}


copyLastSession
mkdir -p ${OUTPUT_DIR}
mkdir -p ${ZIP_DIR}
rm -rf $OUTPUT_DIR/*

#Check if video exists
#[ -e /dev/video0 ] || exit

sleep 1
while [ 1 ]
do
    takePicture &
    sleep $SLEEP_TIME
done
