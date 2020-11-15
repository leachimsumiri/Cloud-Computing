resource "exoscale_security_group" "sg-public" {
  name = "Public Security Group"
}

resource "exoscale_security_group_rule" "http" {
  security_group_id = exoscale_security_group.sg-public.id
  type = "INGRESS"
  protocol = "tcp"
  cidr = "0.0.0.0/0"
  start_port = 80
  end_port = 80
}

resource "exoscale_security_group_rule" "monitoring-node-exporter" {
  security_group_id = exoscale_security_group.sg-public.id
  type = "INGRESS"
  protocol = "tcp"
  cidr = "0.0.0.0/0"
  start_port = 9100
  end_port = 9100
}

resource "exoscale_security_group" "prometheus" {
  name = "Prometheus-Specific Security Group"
}

resource "exoscale_security_group_rule" "prometheus" {
  security_group_id = exoscale_security_group.prometheus.id
  type = "INGRESS"
  protocol = "tcp"
  cidr = "0.0.0.0/0"
  start_port = 9090
  end_port = 9090
}