# The APT Repository of Eruhini

This repo contains xray, v2ray and vaultwarden programs.

## Usage

### 1. Install `curl`

```shell
sudo apt update
sudo apt install curl
```

### 2. Add the repository

```shell
sudo curl -fsSL -o /etc/apt/sources.list.d/eruhini.sources https://bwen19.github.io/apt-repo/eruhini.sources
```

### 3. Import GPG key

```shell
sudo curl -fsSL -o /usr/share/keyrings/eruhini-archive-stable.gpg https://bwen19.github.io/apt-repo/eruhini-archive-stable.gpg
```

### 4. Install packages

```shell
sudo apt update
sudo apt install xray
sudo apt install vaultwarden
```