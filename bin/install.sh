#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt-get update -y
apt-get upgrade -y

#install required programs
apt-get install fswebcam zip -y

#timelapse.sh executable
chmod +x /home/pi/pilapse/bin/timelapse.sh

#copy udev rules file
cp /home/pi/pilapse/bin/99-camera.rules /etc/udev/rules.d/99-camera.rules

#setup startup service
cp /home/pi/pilapse/bin/pilapse.sh /etc/init.d/pilapse
update-rc.d pilapse defaults

chown -R pi:pi /home/pi/pilapse
