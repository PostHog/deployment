resource "digitalocean_database_firewall" "posthog-redis-fw" {
  cluster_id = digitalocean_database_cluster.redis-posthog.id

  rule {
    type  = "tag"
    value = "posthog"
  }
}

resource "digitalocean_database_cluster" "redis-posthog" {
  name       = "posthog-redis-cluster"
  engine     = "redis"
  version    = "5"
  size       = "db-s-1vcpu-1gb"
  region     = var.region
  node_count = 1
}
