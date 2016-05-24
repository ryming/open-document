#!/bin/sh
#
# redis - this script starts and stops the redis-server daemon
#
# chkconfig:   - 85 15
# description:  Redis is a persistent key-value database

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

REDIS_HOME="/usr/local/etc/redis/3.2.0"
REDIS_SERVER="$REDIS_HOME/bin/redis-server"
REDIS_PROG=$(basename $REDIS_SERVER)
REDIS_CONF="$REDIS_HOME/conf/redis.conf"
REDIS_PID="/var/run/redis.pid"
REDIS_LOCK="/var/run/redis.lock"
REDIS_USER="redis"

start() {
    [ -x $REDIS_SERVER ] || exit 5
    [ -f $REDIS_CONF ] || exit 6
    echo -n $"Starting $REDIS_PROG: "
    daemon $REDIS_SERVER $REDIS_CONF
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $REDIS_LOCK
    return $retval
}

stop() {
    echo -n $"Stopping $REDIS_PROG: "
    killproc $REDIS_PROG -QUIT
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $REDIS_LOCK
    return $retval
}

restart() {
    stop
    start
}

reload() {
    echo -n $"Reloading $REDIS_PROG: "
    killproc $REDIS_SERVER -HUP
    RETVAL=$?
    echo
}

force_reload() {
    restart
}

rh_status() {
    status $REDIS_PROG
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}

case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
