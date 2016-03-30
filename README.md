# pilapse
A small program that runs at boot on the raspberry pi and takes an image from the webcam every X seconds

## Installation
To install, just run the following commands:
```
cd /home/pi && git clone https://github.com/matthew-lang/pilapse.git
cd /home/pi/pilapse/bin
chmod +x install.sh
sudo ./install.sh
sudo reboot now
```
And then you're good to go. The script will automatically stop/start when you plug/unplug your camera

## Retrieving the files
TODO


## TODO
* Web interface to download zip files
* ability to build zip file on demand
* fix plug/unplug of usb port to run/stop script
