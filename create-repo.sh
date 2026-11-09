#!/usr/bin/env bash

set -ex

# Debian Packages
[ -d repo ] || mkdir repo
for dir in conf db dists pool; do
  [ -d "repo/$dir" ] || mkdir "repo/$dir"
done

[ -f repo/conf/distributions ] || cat > repo/conf/distributions <<- EOL
Origin: Eruhini
Label: softwares
Suite: stable
Codename: stable
Architectures: amd64
Components: main
Description: APT repository for Eruhini
SignWith: THE_REAL_GPG_PUBLIC_KEY_ID
EOL

for deb_file in ./archive/*.deb; do
    [ -f "$deb_file" ] || continue
    reprepro -b repo includedeb stable "$deb_file"
done

[ -f repo/eruhini.sources ] || cp eruhini.sources ./repo
[ -f repo/.nojekyll ] || cp .nojekyll ./repo

# Update html
XRAY_VERSION=$(reprepro -b repo --list-format '${version}\n' list stable xray)
V2RAY_VERSION=$(reprepro -b repo --list-format '${version}\n' list stable v2ray-rules-dat)
VAULT_VERSION=$(reprepro -b repo --list-format '${version}\n' list stable vaultwarden)

sed -e "s/__XRAY_VERSION__/${XRAY_VERSION}/g" \
    -e "s/__V2RAY_VERSION__/${V2RAY_VERSION}/g" \
    -e "s/__VAULT_VERSION__/${VAULT_VERSION}/g" \
    -e "s/__BUILD_DATE__/$(date -u +%Y-%m-%d)/g" \
    index.html > repo/index.html
