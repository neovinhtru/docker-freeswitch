#!/bin/bash
### BEGIN INIT INFO
# Provides:          Freeswitch
# Required-Start:    $network $firewall 
# Required-Stop:
# Default-Start:     3 5
# Default-Stop:      0 1 2 6
# Short-Description: Freeswitch Back-to-Back User Agent
# Description:       Start the Freeswitch Back-to-Back
#       User Agent to provide VOIP/Multimedia gateway services
### END INIT INFO

FREESWITCH_BIN=/usr/local/freeswitch/bin/freeswitch
test -x $FREESWITCH_BIN || { echo "$FREESWITCH_BIN not installed"; 
        if [ "$1" = "stop" ]; then exit 0;
        else exit 5; fi; }

FREESWITCH_CONFIG=/usr/local/freeswitch/conf/freeswitch.xml
test -r $FREESWITCH_CONFIG || { echo "$FREESWITCH_CONFIG not existing";
        if [ "$1" = "stop" ]; then exit 0;
        else exit 6; fi; }

# Function that sets ulimit values for the daemon
#
do_setlimits() {
        ulimit -c unlimited
        ulimit -d unlimited
        ulimit -f unlimited
        ulimit -i unlimited
        ulimit -n 999999
        ulimit -q unlimited
        ulimit -u unlimited
        ulimit -v unlimited
        ulimit -x unlimited
        ulimit -s 240
        ulimit -l unlimited
        return 0
}
                                                                                                
. /lib/lsb/init-functions
. /etc/rc.status
rc_reset

case "$1" in
    start)
        echo -n "Starting Freeswitch "

        do_setlimits
        /sbin/startproc $FREESWITCH_BIN -c

        rc_status -v
        ;;
    stop)
        echo -n "Shutting down Freeswitch "
        /sbin/killproc $FREESWITCH_BIN

        rc_status -v
        ;;
    try-restart|condrestart)
        if test "$1" = "condrestart"; then
                echo "${attn} Use try-restart ${done}(LSB)${attn} rather than condrestart ${warn}(RH)${norm}"
        fi
        $0 status
        if test $? = 0; then
                $0 restart
        else
                rc_reset
        fi

        rc_status
        ;;
    restart)
        $0 stop
        $0 start

        rc_status
        ;;
    force-reload)
        echo -n "Reload service Freeswitch "
        /sbin/killproc -HUP $FREESWITCH_BIN
        touch /var/run/Freeswitch.pid

        rc_status -v
        ;;
    reload)
        echo -n "Reload service Freeswitch "
        /sbin/killproc -HUP $FREESWITCH_BIN
        touch /var/run/Freeswitch.pid

        rc_status -v
        ;;
    status)
        echo -n "Checking for service Freeswitch "
        /sbin/checkproc $FREESWITCH_BIN

        rc_status -v
        ;;
    probe)
        test /usr/local/freeswitch/conf/freeswitch.xml -nt /var/run/Freeswitch.pid && echo reload
        ;;
    *)
        echo "Usage: $0 {start|stop|status|try-restart|restart|force-reload|reload|probe}"
        exit 1
        ;;
esac
rc_exit
