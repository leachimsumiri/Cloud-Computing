data "exoscale_compute_template" "ubuntu" {
  zone = "at-vie-1"
  name = "Linux Ubuntu 20.04 LTS 64-bit"
}

resource "exoscale_instance_pool" "instancepool" {
  name               = "instancepool"
  description        = "Instance Pool"
  template_id        = data.exoscale_compute_template.ubuntu.id
  service_offering   = "micro"
  size               = 3
  disk_size          = 10
  zone               = "at-vie-1"
  security_group_ids = [exoscale_security_group.sg.id]
  user_data          = <<EOF
#!/bin/bash
set -e
apt update
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo docker pull janoszen/http-load-generator:latest
sudo docker run -d --rm -p 80:8080 janoszen/http-load-generator
EOF
}