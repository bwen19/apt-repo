#!/usr/bin/env bash

set -e

temp_file="$(mktemp /tmp/v2ray-rules-dat.XXXXXX)"
trap 'rm -f "$temp_file"' EXIT
if ! curl -fsSL "https://api.github.com/repos/Loyalsoldier/v2ray-rules-dat/releases/latest" -o "$temp_file"; then
    echo "Error: Cannot get latest version of v2ray-rules-dat!" >&2
    exit 1
fi

remote_version=$(grep tag_name "$temp_file" | awk -F "tag_name" '{printf $2}' | awk -F "," '{printf $1}' | awk -F '"' '{printf $3}')
if [ -z "$remote_version" ]; then
    echo "Error: Cannot parse latest version of v2ray-rules-dat!" >&2
    exit 1
fi
geoip_url="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/$remote_version/geoip.dat"
geosite_url="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/$remote_version/geosite.dat"

[ -d "v2ray-rules-dat" ] || mkdir "v2ray-rules-dat"
if ! curl -fsSL "$geoip_url" -o ./v2ray-rules-dat/geoip.dat; then
    echo "Error: Cannot download geoip.dat!" >&2
    exit 1
fi
if ! curl -fsSL "$geosite_url" -o ./v2ray-rules-dat/geosite.dat; then
    echo "Error: Cannot download geosite.dat!" >&2
    exit 1
fi

echo "$remote_version" > ./v2ray-rules-dat/v2ray-rules-dat_version.txt
