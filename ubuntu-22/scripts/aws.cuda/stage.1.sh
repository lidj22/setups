#!/bin/bash
# tested on aws g4dn.xlarge
# first stage.

export DEBIAN_FRONTEND=noninteractive

# update
apt-get update
apt-get -y upgrade

# install prerequisites
apt-get install -y gcc unzip
apt-get upgrade -y linux-aws

# load the latest kernel version
reboot