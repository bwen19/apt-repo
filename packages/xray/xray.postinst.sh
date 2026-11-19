#!/bin/sh
set -e

case "$1" in
    configure)
        if deb-systemd-helper --quiet was-enabled 'xray.service'; then
            deb-systemd-helper enable 'xray.service' >/dev/null || true
        else
            deb-systemd-helper update-state 'xray.service' >/dev/null || true
        fi

        if [ -d /run/systemd/system ]; then
            systemctl --system daemon-reload >/dev/null || true
            if systemctl --system is-active 'xray.service'; then
                deb-systemd-invoke restart 'xray.service' >/dev/null || true
            fi
        fi
        ;;

    abort-upgrade|abort-remove|abort-deconfigure)
        ;;

    *)
        echo "postinst called with unknown argument: $1" >&2
        exit 1
        ;;
esac

exit 0
