#!/bin/sh
set -e

case "$1" in
    remove)
        if [ -d /run/systemd/system ]; then
            systemctl --system daemon-reload >/dev/null || true
        fi
        ;;

    purge)
        rm -rf /etc/xray

        if [ -x /usr/bin/deb-systemd-helper ]; then
            deb-systemd-helper purge 'xray.service' >/dev/null || true
        fi
        ;;

    upgrade|failed-upgrade|abort-install|abort-upgrade|disappear)
        ;;

    *)
        echo "postrm called with unknown argument: $1" >&2
        exit 1
        ;;
esac

exit 0
