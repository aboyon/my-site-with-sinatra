terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "web_box" {
  image  = "6376601"
  ipv4_address = "104.131.187.9"
  name   = "web-box"
  region = "nyc2"
  size   = "512mb"
  urn    = "do:droplet:3783172"
}
