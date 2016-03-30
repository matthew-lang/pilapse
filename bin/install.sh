#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt-get update -y
apt-get upgrade -y

#install required programs
apt-get install fswebcam upstart zip -y

#timelapse.sh executable
chmod +x /home/pi/pilapse/bin/timelapse.sh

#copy upstart and udev rules files
cp /home/pi/pilapse/bin/pilapse.conf /etc/init/pilapse.conf
cp /home/pi/pilapse/bin/99-camera.rules /etc/udev/rules.d/99-camera.rules


chown -R pi:pi /home/pi/pilapse
