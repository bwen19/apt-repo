#!/usr/bin/env bash
REAL_VERSION=$(cat ./vaultwarden/vaultwarden_version.txt)
[ -d archive ] || mkdir -p archive
cat nfpm/vaultwarden.yaml | sed "s/REAL_VERSION/$REAL_VERSION/g" | tee ./vaultwarden/vaultwarden.yaml
nfpm package -p deb --config ./vaultwarden/vaultwarden.yaml --target ./archive/vaultwarden_${REAL_VERSION}_amd64.deb