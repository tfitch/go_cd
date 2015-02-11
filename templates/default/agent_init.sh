#!/bin/bash
# chkconfig: 2345 90 90
# description: Go Agent
### BEGIN INIT INFO
# Provides: go-agent
# Required-Start: $network $remote_fs
# Required-Stop: $network $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: Start the Go Agent
### END INIT INFO

PID_FILE="/var/run/go-agent/go-agent.pid"

. /etc/default/go-agent

check_proc() {
    pgrep -u goatos -f /usr/share/go-agent/agent-bootstrapper.jar >/dev/null
}

start_go_agent() {
    check_proc
    if [ $? -eq 0 ]; then
       exit -1
    fi
    if [ "$JAVA_HOME" != "" ]; then
       su - goatos -c /usr/share/go-agent/agent.sh
    else
        echo "set JAVA_HOME"
        exit -1
    fi
    # Sleep for a while to see if Cruise bleats about anything
    sleep 15
    check_proc
    if [ $? -eq 0 ]; then
        echo "Started Go Agent."
    else
        echo "Error starting Go Agent."
        exit -1
    fi
}
go_status() {
    check_proc
    if [ $? -eq 0 ]; then
        echo "Go Agent is running."
    else
        echo "Go Agent is stopped."
        exit 3
    fi
}

stop_go_agent() {
    check_proc
    if [ $? -eq 0 ]; then
        pkill -u goatos -f /usr/share/go-agent/agent-bootstrapper.jar
        until [ $? -ne 0 ]; do
            sleep 1
            check_proc
        done
        check_proc
        if [ $? -eq 0 ]; then
            exit -1
        fi
    else
       exit -1
    fi
}


case "$1" in
    start)
        start_go_agent
        ;;
    stop)
        stop_go_agent
        ;;
    restart)
        stop_go_agent
        start_go_agent
        ;;
    status)
        go_status
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
esac

exit 0
