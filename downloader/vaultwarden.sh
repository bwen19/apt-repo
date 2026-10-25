#!/usr/bin/env bash

set -e

temp_dir="$(mktemp -d /tmp/vaultwarden.XXXXXX)"
temp_file="$temp_dir/vaultwarden_version"

if ! curl -s "https://api.github.com/repos/dani-garcia/vaultwarden/releases/latest" -o "$temp_file"; then
    echo "Error: Cannot get latest version of vaultwarden!"
    exit 1
fi

remote_version=$(grep '"tag_name":' "$temp_file" | sed -E 's/.*"([^"]+)".*/\1/')

[ -d "vaultwarden" ] || mkdir "vaultwarden"
docker pull docker.io/vaultwarden/server:${remote_version}-alpine
docker create --name vw docker.io/vaultwarden/server:${remote_version}-alpine
docker cp vw:/vaultwarden ./vaultwarden
docker cp vw:/web-vault ./vaultwarden
docker rm vw

echo ${remote_version} > ./vaultwarden/vaultwarden_version.txt

rm -rf "$temp_dir"
