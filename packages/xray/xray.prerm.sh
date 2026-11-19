#!/bin/sh
set -e

case "$1" in
    remove)
        if [ -x /usr/bin/deb-systemd-invoke ]; then
            deb-systemd-invoke stop 'xray.service' >/dev/null || true
        fi

        if [ -x /usr/bin/deb-systemd-helper ]; then
            deb-systemd-helper disable 'xray.service' >/dev/null || true
        fi
        ;;

    upgrade|deconfigure|failed-upgrade)
        ;;

    *)
        echo "prerm called with unknown argument: $1" >&2
        exit 1
        ;;
esac

exit 0
