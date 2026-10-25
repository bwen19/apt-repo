#!/usr/bin/env bash
REAL_VERSION=$(cat ./v2ray-rules-dat/v2ray-rules-dat_version.txt)
[ -d archive ] || mkdir -p archive
cat nfpm/v2ray-rules-dat.yaml | sed "s/REAL_VERSION/$REAL_VERSION/g" | tee ./v2ray-rules-dat/v2ray-rules-dat.yaml
nfpm package --packager deb --config ./v2ray-rules-dat/v2ray-rules-dat.yaml --target ./archive/v2ray-rules-dat_${REAL_VERSION}_all.deb
