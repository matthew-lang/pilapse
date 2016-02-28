#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt-get update -y
apt-get upgrade -y
apt-get install fswebcam vim git -y
