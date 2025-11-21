# nginx_proxy_pass_exporter
A nginx proxy_pass parser and exporter for Prometheus Pushgateway
## Logic
Parsing nginx sites configuration files, exporter creates **"nginx_upstream_enabled"** metric with labels:
1. upstream_server
2. server_name
3. proxy_pass
4. protocol
5. conf_file

Next, exporter generates Prometheus format string:
> nginx_upstream_enabled{host="some_host", upstream_server="some_upserver", server_name="some_name", proxy_pass="some_proxy_pass", protocol="some_protocol", conf_file="some_conf"} value

and pushing it to the Prometheus Pushgateway
## Installation
Download files: **env** and **proxy_pass_exporter.sh**, or just copy its content to the same files

If you rename "env" file, then you should edit "import" line in the main script (by default it is proxy_pass_exporter.sh):
```bash
#!/bin/bash

source ./env  <----
OIFS=$IFS
... (rest of code)
```

## Configuration
You need to setup vars in the "env" file:
```bash
path_to_sites="/etc/nginx/sites-enabled/"
pushgateway_server_name="127.0.0.1"
pushgateway_server_port="9091"
metric_name="nginx_upstream_enabled"
host=$(hostname)
job_name="nginx_exporter"
sleep_time=14400
```
- **path_to_sites** - path to nginx "sites-enabled" directory, default "/etc/nginx/sites-enabled/"
- **pushgateway_server_name** - dns name or ip of prometheus pushgateway
- **pushgateway_server_port** - port of prometheus pushgateway, default :9091
- **metric_name** - the metric name to send to the prometheus pushgateway, default "nginx_upstream_enabled"*
- **host** - hostname of a server where exporter is running, it will be used in label *"instance"*, default $(hostname)
- **job_name** - value for "job" label, default "nginx_exporter"
- **sleep_time** - how long (in seconds) to wait before next run, set 0 if you want to run script once, default 14400 (run every 4 hours)
