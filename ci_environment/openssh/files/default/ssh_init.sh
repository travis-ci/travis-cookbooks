#! /bin/sh

### BEGIN INIT INFO
# Provides:             sshd
# Required-Start:       $remote_fs $syslog $network
# Required-Stop:        $remote_fs $syslog
# Default-Start:        2 3 4 5
# Default-Stop:         
# Short-Description:    OpenBSD Secure Shell server
### END INIT INFO

set -e

# /etc/init.d/ssh: start and stop the OpenBSD "secure shell(tm)" daemon

test -x /usr/sbin/sshd || exit 0
( /usr/sbin/sshd -\? 2>&1 | grep -q OpenSSH ) 2>/dev/null || exit 0

chrooted() {
    # borrowed from udev's postinst
    # and then borrowed from initramfs-tools's preinst
    if [ "$(stat -c %d/%i /)" = "$(stat -Lc %d/%i /proc/1/root 2>/dev/null)" ]; then
        # the devicenumber/inode pair of / is the same as that of
        # /sbin/init's root, so we're *not* in a chroot and hence
        # return false.
        return 1
    fi
    return 0
}

# The init.d script is only for chroots
if [ -e /etc/init/ssh.conf ] && ! chrooted; then
    exec /lib/init/upstart-job ssh "$@"
fi

umask 022

if test -f /etc/default/ssh; then
    . /etc/default/ssh
fi

. /lib/lsb/init-functions

if [ -n "$2" ]; then
    SSHD_OPTS="$SSHD_OPTS $2"
fi

# Are we running from init?
run_by_init() {
    ([ "$previous" ] && [ "$runlevel" ]) || [ "$runlevel" = S ]
}

check_for_no_start() {
    # forget it if we're trying to start, and /etc/ssh/sshd_not_to_be_run exists
    if [ -e /etc/ssh/sshd_not_to_be_run ]; then 
        if [ "$1" = log_end_msg ]; then
            log_end_msg 0
        fi
        if ! run_by_init; then
            log_action_msg "OpenBSD Secure Shell server not in use (/etc/ssh/sshd_not_to_be_run)"
        fi
        exit 0
    fi
}

check_dev_null() {
    if [ ! -c /dev/null ]; then
        if [ "$1" = log_end_msg ]; then
            log_end_msg 1 || true
        fi
        if ! run_by_init; then
            log_action_msg "/dev/null is not a character device!"
        fi
        exit 1
    fi
}

check_privsep_dir() {
    # Create the PrivSep empty dir if necessary
    if [ ! -d /var/run/sshd ]; then
        mkdir /var/run/sshd
        chmod 0755 /var/run/sshd
    fi
}

check_config() {
    if [ ! -e /etc/ssh/sshd_not_to_be_run ]; then
        /usr/sbin/sshd $SSHD_OPTS -t || exit 1
    fi
}

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

case "$1" in
  start)
        check_privsep_dir
        check_for_no_start
        check_dev_null
        log_daemon_msg "Starting OpenBSD Secure Shell server" "sshd"
        if start-stop-daemon --start --quiet --oknodo --pidfile /var/run/sshd.pid --exec /usr/sbin/sshd -- $SSHD_OPTS; then
            log_end_msg 0
        else
            log_end_msg 1
        fi
        ;;
  stop)
        log_daemon_msg "Stopping OpenBSD Secure Shell server" "sshd"
        if start-stop-daemon --stop --quiet --oknodo --pidfile /var/run/sshd.pid; then
            log_end_msg 0
        else
            log_end_msg 1
        fi
        ;;

  reload|force-reload)
        check_for_no_start
        check_config
        log_daemon_msg "Reloading OpenBSD Secure Shell server's configuration" "sshd"
        if start-stop-daemon --stop --signal 1 --quiet --oknodo --pidfile /var/run/sshd.pid --exec /usr/sbin/sshd; then
            log_end_msg 0
        else
            log_end_msg 1
        fi
        ;;

  restart)
        check_privsep_dir
        check_config
        log_daemon_msg "Restarting OpenBSD Secure Shell server" "sshd"
        start-stop-daemon --stop --quiet --oknodo --retry 30 --pidfile /var/run/sshd.pid
        check_for_no_start log_end_msg
        check_dev_null log_end_msg
        if start-stop-daemon --start --quiet --oknodo --pidfile /var/run/sshd.pid --exec /usr/sbin/sshd -- $SSHD_OPTS; then
            log_end_msg 0
        else
            log_end_msg 1
        fi
        ;;

  try-restart)
        check_privsep_dir
        check_config
        log_daemon_msg "Restarting OpenBSD Secure Shell server" "sshd"
        set +e
        start-stop-daemon --stop --quiet --retry 30 --pidfile /var/run/sshd.pid
        RET="$?"
        set -e
        case $RET in
            0)
                # old daemon stopped
                check_for_no_start log_end_msg
                check_dev_null log_end_msg
                if start-stop-daemon --start --quiet --oknodo --pidfile /var/run/sshd.pid --exec /usr/sbin/sshd -- $SSHD_OPTS; then
                    log_end_msg 0
                else
                    log_end_msg 1
                fi
                ;;
            1)
                # daemon not running
                log_progress_msg "(not running)"
                log_end_msg 0
                ;;
            *)
                # failed to stop
                log_progress_msg "(failed to stop)"
                log_end_msg 1
                ;;
        esac
        ;;

  status)
        status_of_proc -p /var/run/sshd.pid /usr/sbin/sshd sshd && exit 0 || exit $?
        ;;

  *)
        log_action_msg "Usage: /etc/init.d/ssh {start|stop|reload|force-reload|restart|try-restart|status}"
        exit 1
esac

exit 0
