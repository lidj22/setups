#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# virtualbox
wget -O virtualbox.deb https://download.virtualbox.org/virtualbox/7.0.12/virtualbox-7.0_7.0.12-159484~Ubuntu~jammy_amd64.deb \
    && dpkg -i virtualbox.deb \
    && apt-get --fix-broken install \
    && dpkg -i virtualbox.deb \
    && rm virtualbox.deb

# vagrant
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install vagrant