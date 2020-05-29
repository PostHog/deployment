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
      "docker run -t -i --restart always --publish 8000:8000 -e IS_DOCKER=true -e DISABLE_SECURE_SSL_REDIRECT=1 -e SECRET_KEY=${random_string.random.result} -e DATABASE_URL=postgres://${digitalocean_database_cluster.postgres-posthog.user}:${digitalocean_database_cluster.postgres-posthog.password}@${digitalocean_database_cluster.postgres-posthog.private_host}:${digitalocean_database_cluster.postgres-posthog.port}/${digitalocean_database_cluster.postgres-posthog.database} -e REDIS_URL=redis://${digitalocean_database_cluster.redis-posthog.private_host}:${digitalocean_database_cluster.redis-posthog.port} posthog/posthog:latest"
    ]
  }
}

resource "digitalocean_droplet" "posthog-2" {
  image              = "ubuntu-18-04-x64"
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
      "export PATH=$PATH:/usr/bin",
      "sudo apt -y install apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable\"",
      "sudo apt-get update",
      "sudo apt -y install docker-ce",
      "sudo apt-get -y install docker",
      "docker run -t -i --restart always --publish 8000:8000 -e IS_DOCKER=true -e DISABLE_SECURE_SSL_REDIRECT=1 -e SECRET_KEY=${random_string.random.result} -e DATABASE_URL=postgres://${digitalocean_database_cluster.postgres-posthog.user}:${digitalocean_database_cluster.postgres-posthog.password}@${digitalocean_database_cluster.postgres-posthog.private_host}:${digitalocean_database_cluster.postgres-posthog.port}/${digitalocean_database_cluster.postgres-posthog.database} -e REDIS_URL=redis://${digitalocean_database_cluster.redis-posthog.private_host}:${digitalocean_database_cluster.redis-posthog.port} posthog/posthog:latest"
    ]
  }
}
