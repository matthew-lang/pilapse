#!/bin/bash


BASE_DIR="$( cd "$( dirname "$0" )" && pwd )"
PICTURE_DIR="${BASE_DIR}/pictures"
QUEUE_DIR="${BASE_DIR}/queue"
ZIP_DIR="${BASE_DIR}/zips"

checkArguments(){
  if [[ $# -eq 0 ]]; then
    echo "No arguments supplied"
    return 1;
  fi

  SLEEP_TIME=$1

  if [ "$SLEEP_TIME" -lt "2" ]; then
    echo 'You must enter a number larger than 2 for the sleep time'
    return 1;
  fi
}

mkdirs(){
  mkdir -p $BASE_DIR
  mkdir -p $PICTURE_DIR
  mkdir -p $QUEUE_DIR
  mkdir -p $ZIP_DIR
}

transferToQueue(){
  #Check to see how many sessions are queued (num folders in $QUEUE_DIR)
  local queue_length=$(printf "%06d" $(ls -1 ${QUEUE_DIR} | wc -l))
  #renumber all folders if needed
  if [ ! -d "$QUEUE_DIR/session-000000" ]; then
    for (( i=0; i<$queue_length; i++ ))
    do
      local position=$(($i + 1));
      echo $position
      local num_var=$(printf "%06d" $i)
      local original_fname=$(ls -1 ${QUEUE_DIR} | sed -n -e '${position}p')
      echo "Renaming ${original_fname} to session-${num_var}"
      mv "${QUEUE_DIR}/${original_fname}" "${QUEUE_DIR}/session-${num_var}"
    done
  fi

  #Check to see if there are any photos from the previous session
  local num_pics=$(printf "%06d" $(ls -1 ${PICTURE_DIR} | wc -l))
  if [ "$num_pics" -eq "0" ]; then
    echo "No pictures found from previous session";
    return 0;
  fi

  #Move previous session's pictures into queue dir
  echo "Transferring $num_pics previous session pictures to the queue"
  mv "${PICTURE_DIR}" "${QUEUE_DIR}/session-${queue_length}"
  mkdir -p "${PICTURE_DIR}"
}

zipSessions(){
  echo "Zipping Sessions"
}

pictureLoop(){
  while [ 1 ]
  do
    takePicture &
    sleep $SLEEP_TIME
  done
}

takePicture(){
  [ -e /dev/video0 ] || exit
  echo "Taking Picture"
  NUM_FILES=$(printf "%06d" $(ls -1 ${PICTURE_DIR} | wc -l))
  PIC_NAME=${PICTURE_DIR}/${NUM_FILES}-photo.jpg
  #streamer -f jpeg -o /home/pi/timelapse-photos/${NUM_FILES}-photo.jpeg -s 1920x1080 &
  fswebcam -r 1920x1080 --jpeg 100 -D 0 --quiet --no-overlay --no-timestamp --no-title --no-underlay --no-banner ${PIC_NAME} || echo "unable to take photo"
  echo "Saved."
}

fail() {
  local message="$1"
  echo "FAILURE!"
  echo "${message}"
  echo ""
  exit 1;
}

echo "Staring PiLapse"
checkArguments $1 || { fail "Error With Arguments"; }
#make sure the directory structure is there
mkdirs
#queue up pictures that were taken during the last session
transferToQueue
zipSessions& 
pictureLoop
