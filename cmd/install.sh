#!/bin/bash

mkdir /usr/local/bin/process_exporter
mv -f ./process-exporter/process_exporter /usr/local/bin/process_exporter
mv -f config.yml /usr/local/bin/process_exporter

chmod +x /usr/local/bin/process_exporter/*

cat<<EOF >/usr/lib/systemd/system/process-exporter.service
[Unit]
Description=process exporter
After=network.target

[Service]
User=root
Type=simple
ExecStart=/usr/local/bin/process_exporter/process_exporter -config.path /usr/local/bin/process_exporter/config.yml
Restart=always

[Install]
WantedBy=multi-user.target

EOF

chmod 754 /usr/lib/systemd/system/process-exporter.service
systemctl enable process-exporter.service
systemctl stop process-exporter
systemctl start process-exporter

if [[ $? = 0 ]]; then
    echo "install Success!!"
else
    echo "install Failed !!"
fi
