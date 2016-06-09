#! /bin/sh
### BEGIN INIT INFO
# Provides:          pilapse
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Manage my cool stuff
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin

. /lib/init/vars.sh
. /lib/lsb/init-functions
# If you need to source some other scripts, do it here

case "$1" in
  start)
    log_begin_msg "Starting my super cool service"
    killall -q timelapse.sh
    runuser -l pi -c '/home/pi/pilapse/bin/timelapse.sh 3 >> /home/pi/timelapse.log &'
    log_end_msg $?
    exit 0
    ;;
  stop)
    log_begin_msg "Stopping the coolest service ever unfortunately"

    # do something to kill the service or cleanup or nothing
    killall timelapse.sh
    log_end_msg $?
    exit 0
    ;;
  *)
    echo "Usage: /etc/init.d/<your script> {start|stop}"
    exit 1
    ;;
esac