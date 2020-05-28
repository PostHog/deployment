resource "digitalocean_droplet" "posthog-1" {
  image              = "ubuntu-18-04-x64"
  name               = "poasthog-1"
  region             = "nyc2"
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
      # install nginx
      "sudo apt install apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable",
      "sudo apt-get update",
      "sudo apt install docker-ce",

      "sudo apt-get -y install docker",
      "docker run -t -i --restart always --rm --publish 8000:8000 -v posthog/posthog:latest"
    ]
  }
}

resource "digitalocean_droplet" "posthog-2" {
  image              = "ubuntu-18-04-x64"
  name               = "poasthog-2"
  region             = "nyc2"
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
      # install nginx
      "sudo apt install apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable",
      "sudo apt-get update",
      "sudo apt install docker-ce",

      "sudo apt-get -y install docker",
      "docker run -t -i --restart always --rm --publish 8000:8000 -v posthog/posthog:latest"
    ]
  }
}