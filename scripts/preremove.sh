#!/bin/sh
set -e

if [ "$1" = remove ] && [ -d /run/systemd/system ]; then
    deb-systemd-invoke stop "$DPKG_MAINTSCRIPT_PACKAGE.service"
fi
