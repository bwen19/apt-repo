#!/usr/bin/env bash

set -ex

V2RAY_VERSION=$(cat ./v2ray-rules-dat/v2ray-rules-dat_version.txt)
VAULT_VERSION=$(cat ./vaultwarden/vaultwarden_version.txt)
XRAY_VERSION=$(cat ./xray-core/xray_version.txt)

[ -d repo ] || mkdir -p repo
sed -e "s/__XRAY_VERSION__/${XRAY_VERSION}/g" \
    -e "s/__V2RAY_VERSION__/${V2RAY_VERSION}/g" \
    -e "s/__VAULT_VERSION__/${VAULT_VERSION}/g" \
    -e "s/__BUILD_DATE__/$(date -u +%Y-%m-%d)/g" \
    index.html > repo/index.html
cp .nojekyll ./repo
