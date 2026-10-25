#!/usr/bin/env bash

set -e

temp_dir="$(mktemp -d /tmp/xray.XXXXXX)"
temp_file="$temp_dir/xray_version"

if ! curl -s "https://api.github.com/repos/XTLS/Xray-core/releases/latest" -o "$temp_file"; then
    echo "Error: Cannot get latest version of xray!"
    exit 1
fi

remote_version=$(grep '"tag_name":' "$temp_file" | sed -E 's/.*"([^"]+)".*/\1/')
url="https://github.com/XTLS/Xray-core/releases/download/$remote_version/Xray-linux-64.zip"

curl -L "$url" -o "$temp_dir/Xray-linux-64.zip"
unzip -q "$temp_dir/Xray-linux-64.zip" -d ./xray-core
upx --lzma --best ./xray-core/xray
echo ${remote_version#v} > ./xray-core/xray_version.txt

rm -rf "$temp_dir"