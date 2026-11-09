#!/usr/bin/env bash

set -e
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

work_dir="v2ray-rules-dat"
[ -d "$work_dir" ] || mkdir "$work_dir"
trap 'rm -rf "$work_dir"' EXIT

version_file="$work_dir/releases_latest"
if ! curl -fsSL "https://api.github.com/repos/Loyalsoldier/v2ray-rules-dat/releases/latest" -o "$version_file"; then
    echo "Error: Cannot get latest version of v2ray-rules-dat!" >&2
    exit 1
fi

remote_version=$(jq -r '.tag_name | strings' "$version_file")
remote_version=${remote_version#v}

rm -f ./archive/v2ray-rules-dat_*.deb
if [[ ! "$remote_version" =~ ^[0-9]+$ ]]; then
    echo "Skip v2ray-rules-dat: empty or unsupported version '$remote_version'"
    exit 0
fi

local_version=""
if [ -f repo/conf/distributions ]; then
    local_version=$(reprepro -b repo --list-format '${version}\n' list stable v2ray-rules-dat)
fi

# nFPM expands the numeric release tag to <tag>.0.0.
if [ -z "$local_version" ] || dpkg --compare-versions "${remote_version}.0.0" gt "$local_version"; then
    geoip_url="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/$remote_version/geoip.dat"
    geoip_file="$work_dir/geoip.dat"
    if ! curl -fsSL "$geoip_url" -o "$geoip_file"; then
        echo "Error: Cannot download geoip.dat!" >&2
        exit 1
    fi

    geosite_url="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/$remote_version/geosite.dat"
    geosite_file="$work_dir/geosite.dat"
    if ! curl -fsSL "$geosite_url" -o "$geosite_file"; then
        echo "Error: Cannot download geosite.dat!" >&2
        exit 1
    fi

    [ -d archive ] || mkdir archive
    yaml_file="$work_dir/v2ray-rules-dat.yaml"
    cat nfpm/v2ray-rules-dat.yaml | sed "s/REAL_VERSION/$remote_version/g" | tee "$yaml_file"
    nfpm package --packager deb --config "$yaml_file" --target "./archive/v2ray-rules-dat_${remote_version}_all.deb"
fi
