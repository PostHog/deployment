resource "digitalocean_database_firewall" "posthog-redis-fw" {
  cluster_id = digitalocean_database_cluster.redis-posthog.id

  rule {
    type  = "droplet"
    value = digitalocean_droplet.posthog-1.id
  }
}

resource "digitalocean_database_cluster" "redis-posthog" {
  name       = "posthog-redis-cluster"
  engine     = "redis"
  version    = "5"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc1"
  node_count = 1
}
