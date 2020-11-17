resource "exoscale_compute" "prometheus" {
  display_name       = "prometheus"
  template_id        = data.exoscale_compute_template.ubuntu.id
  zone               = "at-vie-1"
  size               = "Medium"
  disk_size          = 10
  security_group_ids = [exoscale_security_group.prometheus.id]
  user_data          = <<EOF
#!/bin/bash
set -e
apt update
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

BACK_PID=$!
wait $BACK_PID

sudo mkdir /prometheus
sudo touch /prometheus/prometheus.yml
sudo echo "${data.template_file.prometheus_yaml.rendered}" > /prometheus/prometheus.yml
sudo chown -R ubuntu:ubuntu /prometheus

mkdir -p /srv/service-discovery/
chmod a+rwx /srv/service-discovery/

sudo docker run -d \
    -v /srv/service-discovery:/var/run/prometheus-sd-exoscale-instance-pools \
    janoszen/prometheus-sd-exoscale-instance-pools \
    --exoscale-api-key ${var.exoscale_key} \
    --exoscale-api-secret ${var.exoscale_secret} \
    --exoscale-zone-id 4da1b188-dcd6-4ff5-b7fd-bde984055548 \
    --instance-pool-id ${exoscale_instance_pool.instancepool.id} \
    -prometheus-port 9100

BACK_PID2=$!
wait $BACK_PID2

sudo docker run -d \
    -p 9090:9090 \
    -v /prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
    -v /srv/service-discovery/:/srv/service-discovery/ \
    prom/prometheus
EOF
}