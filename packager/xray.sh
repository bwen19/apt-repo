#!/usr/bin/env bash

set -e
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

work_dir="xray-core"
[ -d "$work_dir" ] || mkdir "$work_dir"
trap 'rm -rf "$work_dir"' EXIT

version_file="$work_dir/releases_latest"
if ! curl -fsSL "https://api.github.com/repos/XTLS/Xray-core/releases/latest" -o "$version_file"; then
    echo "Error: Cannot get latest version of xray!"
    exit 1
fi

remote_version=$(jq -r '.tag_name | strings' "$version_file")
remote_version=${remote_version#v}

rm -f ./archive/xray_*.deb
if [[ ! "$remote_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Skip xray: empty or unsupported version '$remote_version'"
    exit 0
fi

local_version=""
if [ -f repo/conf/distributions ]; then
    local_version=$(reprepro -b repo --list-format '${version}\n' list stable xray)
fi

if [ -z "$local_version" ] || dpkg --compare-versions "$remote_version" gt "$local_version"; then
    xray_url="https://github.com/XTLS/Xray-core/releases/download/v$remote_version/Xray-linux-64.zip"
    xray_file="$work_dir/Xray-linux-64.zip"
    curl -fsSL "$xray_url" -o "$xray_file"
    unzip -q "$xray_file" -d "$work_dir"

    [ -d archive ] || mkdir archive
    yaml_file="$work_dir/xray.yaml"
    cat nfpm/xray.yaml | sed "s/REAL_VERSION/$remote_version/g" | tee "$yaml_file"
    nfpm package --packager deb --config "$yaml_file" --target ./archive/xray_${remote_version}_amd64.deb
fi
