#!/usr/bin/env bash

set -e
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

work_dir="vaultwarden"
[ -d "$work_dir" ] || mkdir "$work_dir"
trap 'rm -rf "$work_dir"' EXIT

version_file="$work_dir/releases_latest"
if ! curl -fsSL "https://api.github.com/repos/dani-garcia/vaultwarden/releases/latest" -o "$version_file"; then
    echo "Error: Cannot get latest version of vaultwarden!"
    exit 1
fi

remote_version=$(jq -r '.tag_name | strings' "$version_file")
remote_version=${remote_version#v}

rm -f ./archive/vaultwarden_*.deb
if [[ ! "$remote_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Skip vaultwarden: empty or unsupported version '$remote_version'"
    exit 0
fi

local_version=""
if [ -f repo/conf/distributions ]; then
    local_version=$(reprepro -b repo --list-format '${version}\n' list stable vaultwarden)
fi

if [ -z "$local_version" ] || dpkg --compare-versions "$remote_version" gt "$local_version"; then
    docker pull docker.io/vaultwarden/server:${remote_version}-alpine
    docker create --name vw docker.io/vaultwarden/server:${remote_version}-alpine
    docker cp vw:/vaultwarden "$work_dir"
    docker cp vw:/web-vault "$work_dir"
    docker rm vw

    [ -d archive ] || mkdir archive
    yaml_file="$work_dir/vaultwarden.yaml"
    cat nfpm/vaultwarden.yaml | sed "s/REAL_VERSION/$remote_version/g" | tee "$yaml_file"
    nfpm package --packager deb --config "$yaml_file" --target ./archive/vaultwarden_${remote_version}_amd64.deb
fi
