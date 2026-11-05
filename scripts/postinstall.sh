#!/bin/sh
set -e

[ "$1" = configure ] || exit 0

# Record unit links for purge without enabling the service.
deb-systemd-helper update-state "$DPKG_MAINTSCRIPT_PACKAGE.service" >/dev/null || true

if [ -d /run/systemd/system ]; then
    systemctl daemon-reload
    deb-systemd-invoke try-restart "$DPKG_MAINTSCRIPT_PACKAGE.service"
fi
