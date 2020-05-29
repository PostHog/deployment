variable "region" {
  type    = string
  default = "nyc1"
}
resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}

resource "digitalocean_droplet" "posthog-1" {
  image              = "ubuntu-18-04-x64"
  name               = "posthog-1"
  tags               = ["posthog"]
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
      "sudo apt -y install apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable\"",
      "sudo apt-get update",
      "sudo apt -y install docker-ce",
      "sudo apt-get -y install docker",
      "sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "git clone https://github.com/PostHog/posthog.git",
      "cd posthog",
      "docker-compose -f docker-compose.yml up -d" 
    ]
  }
}


resource "digitalocean_firewall" "posthog" {
  name = "only-22-80-and-443"

  droplet_ids = [digitalocean_droplet.posthog-1.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["192.168.1.0/24", "2002:1:2::/48"]
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