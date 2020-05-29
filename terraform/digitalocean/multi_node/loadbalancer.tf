variable "posthog_fqdn" {
  type = string
}

resource "digitalocean_certificate" "cert" {
  name    = "le-terraform-posthog"
  type    = "lets_encrypt"
  domains = [var.posthog_fqdn]
}

resource "digitalocean_loadbalancer" "posthog-lb" {
  name        = "posthog-lb"
  region      = var.region
  droplet_tag = "posthog"

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 8000
    target_protocol = "http"
    certificate_id  = digitalocean_certificate.cert.id
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }
}
