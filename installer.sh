#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt-get update -y
apt-get upgrade -y
apt-get install fswebcam vim upstart git -y
git clone https://github.com/matthew-lang/timelapse-pi.git
chmod +x /home/pi/timelapse-pi/timelapse.sh
cp /home/pi/timelapse-pi/timelapse.conf /etc/init/timelapse.conf
