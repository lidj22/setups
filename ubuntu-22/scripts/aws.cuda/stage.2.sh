#!/bin/bash

# account requires S3 get permissions.
read -p "Enter AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -p "Enter AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
read -p "Enter AWS Default Region (e.g., us-east-1): " AWS_DEFAULT_REGION

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION

export DEBIAN_FRONTEND=noninteractive

# install gcc
apt-get install -y gcc make linux-headers-$(uname -r)

# disable noveau
cat << EOF | sudo tee --append /etc/modprobe.d/blacklist.conf
blacklist vga16fb
blacklist nouveau
blacklist rivafb
blacklist nvidiafb
blacklist rivatv
EOF

# update grub configuration
echo 'GRUB_CMDLINE_LINUX="rdblacklist=nouveau"' >> /etc/default/grub
update-grub

# install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
echo "[default]
region = $AWS_DEFAULT_REGION
output = json" >> ~/.aws/config

# install nvidia drivers
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/install-nvidia-driver.html#nvidia-GRID-driver
aws s3 cp --recursive s3://ec2-linux-nvidia-drivers/latest/ .
chmod +x NVIDIA-Linux-x86_64*.run
sudo /bin/sh ./NVIDIA-Linux-x86_64*.run -s

# install CUDA
# https://developer.nvidia.com/cuda-12-1-0-download-archive
# https://askubuntu.com/questions/885610/nvcc-version-command-says-nvcc-is-not-installed
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda-repo-ubuntu2204-12-1-local_12.1.0-530.30.02-1_amd64.deb
dpkg -i cuda-repo-ubuntu2204-12-1-local_12.1.0-530.30.02-1_amd64.deb
cp /var/cuda-repo-ubuntu2204-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
apt-get update
apt-get -y install cuda

echo 'export PATH="/usr/local/cuda-12.1/bin:$PATH"' >> /home/ubuntu/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda-12.1/lib64:$LD_LIBRARY_PATH"' >> /home/ubuntu/.bashrc

# test
nvidia-smi
nvcc --version

# reboot