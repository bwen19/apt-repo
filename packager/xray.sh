#!/usr/bin/env bash
REAL_VERSION=$(cat ./xray-core/xray_version.txt)
[ -d archive ] || mkdir -p archive
cat nfpm/xray.yaml | sed "s/REAL_VERSION/$REAL_VERSION/g" | tee ./xray-core/xray.yaml
nfpm package -p deb --config ./xray-core/xray.yaml --target ./archive/xray_${REAL_VERSION}_amd64.deb
