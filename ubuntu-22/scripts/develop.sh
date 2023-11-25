#!/bin/bash

# envs
USER_NAME=$(getent passwd 1000 | awk -F: '{print $1}')
USER_HOME=$(getent passwd 1000 | cut -d: -f6)
export DEBIAN_FRONTEND=noninteractive

# install
apt-get update && apt-get upgrade -y
apt-get install -y net-tools curl
apt-get install -y btop htop
apt-get install -y vim tmux

# node
apt-get install -y ca-certificates curl gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install nodejs -y

# python
apt-get install -y python-is-python3 python3-pip
python3 -m pip install virtualenv

# java
apt-get install -y openjdk-11-jdk default-jdk

# ssh
apt-get install -y openssh-server
systemctl enable ssh
systemctl start ssh

# fail2ban
apt-get install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# wireguard
apt-get install -y wireguard

# docker (https://docs.docker.com/engine/install/ubuntu/)
# apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -aG docker $USER_NAME
