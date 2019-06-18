#!/bin/bash

cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar xzvf node_exporter-0.18.1.linux-amd64.tar.gz

cat > /lib/systemd/system/node_exporter.service <<EOF
[Unit]
Description=node_exporter
After=network.target

[Service]
User=root
ExecStart=/opt/node_exporter-0.18.1.linux-amd64/node_exporter --no-collector.arp --no-collector.bcache --no-collector.conntrack --no-collector.edac --no-collector.entropy --no-collector.infiniband --no-collector.ipvs --no-collector.loadavg --no-collector.mdadm --no-collector.nfs --no-collector.nfsd --no-collector.netstat --no-collector.sockstat --no-collector.stat --no-collector.textfile --no-collector.time  --no-collector.timex --no-collector.uname --no-collector.vmstat --no-collector.wifi --no-collector.xfs
WorkingDirectory=/opt/node_exporter-0.18.1.linux-amd64
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable node_exporter
systemctl daemon-reload
service node_exporter start

curl localhost:9100/metrics
rm node_exporter-0.18.1.linux-amd64.tar.gz
