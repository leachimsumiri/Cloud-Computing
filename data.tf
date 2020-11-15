data "exoscale_compute_template" "ubuntu" {
  name = "Linux Ubuntu 20.04 LTS 64-bit"
  zone = "at-vie-1"
}

data "template_file" "prometheus_yaml" {
  template = file("prometheus.yml")
}