# IPMItools Prometheus textfile wrapper

Simple wrapper to run the `ipmitools` Prometheus collector from the [`node_exporter`
community scripts][1] collection as a *systemd* service.

## Dependencies

Only the `ipmitool` binary is required.

## Installation

The instructions below are assuming the `node_exporter` textfile directory is
`/var/lib/node_exporter/textfile_collector/`.

```bash
cd /opt/
git clone https://github.com/imcf/ipmitool-prometheus-textfile
cd ipmitool-prometheus-textfile
cp ipmitool-prometheus-textfile.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now ipmitool-prometheus-textfile.service
```

[1]: https://github.com/prometheus-community/node-exporter-textfile-collector-scripts
