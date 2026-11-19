#!/bin/sh
set -e

case "$1" in
    configure)
        if ! getent passwd vaultwarden >/dev/null; then
            adduser --system --group --no-create-home --home /var/lib/vaultwarden vaultwarden
        fi

        mkdir -p /var/lib/vaultwarden
        chown vaultwarden:vaultwarden /var/lib/vaultwarden

        if deb-systemd-helper --quiet was-enabled 'vaultwarden.service'; then
            deb-systemd-helper enable 'vaultwarden.service' >/dev/null || true
        else
            deb-systemd-helper update-state 'vaultwarden.service' >/dev/null || true
        fi

        if [ -d /run/systemd/system ]; then
            systemctl --system daemon-reload >/dev/null || true
            if systemctl --system is-active 'vaultwarden.service'; then
                deb-systemd-invoke restart 'vaultwarden.service' >/dev/null || true
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
