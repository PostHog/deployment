variable "region" {
  type    = string
  default = "nyc1"
}
resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}

resource "digitalocean_droplet" "posthog-solo" {
  image              = "docker-18-04"
  name               = "posthog-solo"
  tags               = ["posthog-solo"]
  region             = var.region
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    var.ssh_fingerprint
  ]
  connection {

    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt -y install apt-transport-https ca-certificates curl git software-properties-common",
      "git clone https://github.com/PostHog/deployment.git",
      "cd deployment/terraform/digitalocean/single_node",
      "docker-compose -f docker-compose.do.yml up -d"
    ]
  }
}


resource "digitalocean_firewall" "posthog-fw" {
  name = "only-22-80-and-443"

  droplet_ids = [digitalocean_droplet.posthog-solo.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
