terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
variable "ssh_fingerprint" {}
variable "site_cdn" {}
variable "pvt_key" {} # path to you private key. Won't be imported

data "template_file" "userdata" {
  template = "${file("./recipes/shell/provision.sh")}"
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "web_box" {
  image     = "ubuntu-20-04-x64"
  name      = "web-box"
  region    = "nyc1"
  size      = "s-1vcpu-1gb"
  tags      = ["ruby","app"]
  ssh_keys  = [var.ssh_fingerprint]
  user_data = "${data.template_file.userdata.rendered}"

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /app",
      "echo SITE_CDN=${var.site_cdn} > /app/.env",
      "git clone https://github.com/aboyon/my-site-with-sinatra.git /app"
    ]
  }
}
