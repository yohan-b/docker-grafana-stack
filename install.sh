#!/bin/bash
#Absolute path to this script
SCRIPT=$(readlink -f $0)
#Absolute path this script is in
SCRIPTPATH=$(dirname $SCRIPT)
STACK=$(basename "$SCRIPTPATH")

mkdir -p /mnt/volumes/var_lib_grafana/data
chown -R 472:472 /mnt/volumes/var_lib_grafana/data
mkdir -p /mnt/volumes/etc_grafana/data 
chown -R root:root /mnt/volumes/etc_grafana/data 
chmod -R a+r /mnt/volumes/etc_grafana/data 
mkdir -p /mnt/volumes/var_log_grafana/data
chown -R 472:472 /mnt/volumes/var_log_grafana/data

cat << EOF > /etc/systemd/system/${STACK}.service
[Unit]
Description=Starting ${STACK}
After=network-online.target firewalld.service docker.service docker.socket
Wants=network-online.target docker.service
Requires=docker.socket

[Service]
Type=oneshot
User=$SUDO_USER
ExecStart=$SCRIPTPATH/start.sh

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable ${STACK}.service
