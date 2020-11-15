terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
    }
  }
}

variable "exoscale_key" {
  description = "The Exoscale API key" 
  type = string
}

variable "exoscale_secret" {
  description = "The Exoscale API secret"
  type = string
}

provider "exoscale" {
  key = var.exoscale_key
  secret = var.exoscale_secret
}