#!/usr/bin/env bash

set -ex

# Debian Packages
[ -d repo ] || mkdir -p repo
for dir in conf db dists pool; do
  [ -d "repo/$dir" ] || mkdir -p "repo/$dir"
done

cat > repo/conf/distributions <<- EOL
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
    reprepro -b repo includedeb stable "$deb_file"
done

# Source Config File
cp eruhini.sources ./repo
