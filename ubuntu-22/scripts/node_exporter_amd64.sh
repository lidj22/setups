#!/bin/bash

wget https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz
tar zxf node_exporter-1.8.0.linux-amd64.tar.gz
mv node_exporter-1.8.0.linux-amd64/node_exporter /usr/local/bin
useradd -rs /bin/false node_exporter
echo '[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/node_exporter.service

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter