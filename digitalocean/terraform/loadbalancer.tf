resource "digitalocean_loadbalancer" "posthog-lb" {
  name   = "posthog-lb"
  region = "nyc2"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 8000
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = [digitalocean_droplet.posthog-1.id, digitalocean_droplet.posthog-2.id]
}
