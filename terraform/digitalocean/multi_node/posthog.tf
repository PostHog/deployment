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
  image              = "docker-18-04"
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
      "sudo apt -y install apt-transport-https ca-certificates git curl software-properties-common",
      "docker run -d -t -i --restart always --publish 8000:8000 -e IS_DOCKER=true -e DISABLE_SECURE_SSL_REDIRECT=1 -e SECRET_KEY=${random_string.random.result} -e DATABASE_URL=postgres://${digitalocean_database_cluster.postgres-posthog.user}:${digitalocean_database_cluster.postgres-posthog.password}@${digitalocean_database_cluster.postgres-posthog.private_host}:${digitalocean_database_cluster.postgres-posthog.port}/${digitalocean_database_cluster.postgres-posthog.database} -e REDIS_URL=rediss://${digitalocean_database_cluster.redis-posthog.user}:${digitalocean_database_cluster.redis-posthog.password}@${digitalocean_database_cluster.redis-posthog.private_host}:${digitalocean_database_cluster.redis-posthog.port} posthog/posthog:latest-release"
    ]
  }
}

resource "digitalocean_droplet" "posthog-2" {
  image              = "docker-18-04"
  name               = "posthog-2"
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
      # this is just to stagger the deploys so posthog1 gets to do the migrations 
      "echo ${digitalocean_droplet.posthog-1.ipv4_address}",
      "export PATH=$PATH:/usr/bin",
      "sudo apt -y install apt-transport-https ca-certificates git curl software-properties-common",
      "docker run -d -t -i --restart always --publish 8000:8000 -e IS_DOCKER=true -e DISABLE_SECURE_SSL_REDIRECT=1 -e SECRET_KEY=${random_string.random.result} -e DATABASE_URL=postgres://${digitalocean_database_cluster.postgres-posthog.user}:${digitalocean_database_cluster.postgres-posthog.password}@${digitalocean_database_cluster.postgres-posthog.private_host}:${digitalocean_database_cluster.postgres-posthog.port}/${digitalocean_database_cluster.postgres-posthog.database} -e REDIS_URL=rediss://${digitalocean_database_cluster.redis-posthog.user}:${digitalocean_database_cluster.redis-posthog.password}@${digitalocean_database_cluster.redis-posthog.private_host}:${digitalocean_database_cluster.redis-posthog.port} posthog/posthog:latest-release"
    ]
  }
}


resource "digitalocean_firewall" "posthog-fw" {
  name = "only-22-80-and-443"

  tags = ["posthog"]

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
