resource "exoscale_nlb" "nlb" {
  name        = "nlb"
  description = "Network Load Balancer"
  zone        = "at-vie-1"
}

resource "exoscale_nlb_service" "nlb_service" {
  zone             = "at-vie-1"
  name             = "nlb_service"
  description      = "Network Load Balancer Service"
  nlb_id           = exoscale_nlb.nlb.id
  instance_pool_id = exoscale_instance_pool.instancepool.id
  protocol         = "tcp"
  port             = 80
  target_port      = 80
  strategy         = "round-robin"

  healthcheck {
    port     = 80
    mode     = "http"
    uri      = "/health"
    interval = 5
    timeout  = 3
    retries  = 1
  }
}