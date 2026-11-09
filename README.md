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

### 5. Configure and start services

Edit `/etc/xray/config.json` with your Xray configuration; the installed file is an empty template. Then validate and start it:

```shell
sudo xray run -test -config /etc/xray/config.json
sudo systemctl enable --now xray
```

Vaultwarden settings are in `/etc/vaultwarden/vaultwarden.env` (default port: `8080`):

```shell
sudo systemctl enable --now vaultwarden
```
