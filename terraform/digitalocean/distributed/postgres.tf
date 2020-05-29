resource "digitalocean_database_firewall" "posthog-fw" {
  cluster_id = digitalocean_database_cluster.postgres-posthog.id

  rule {
    type  = "tag"
    value = "posthog"
  }
}

resource "digitalocean_database_db" "database-posthog" {
  cluster_id = digitalocean_database_cluster.postgres-posthog.id
  name       = "posthog"
}

resource "digitalocean_database_user" "user-posthog" {
  cluster_id = digitalocean_database_cluster.postgres-posthog.id
  name       = "posthog"
}

resource "digitalocean_database_cluster" "postgres-posthog" {
  name       = "posthog-postgres-cluster"
  engine     = "pg"
  version    = "11"
  size       = "db-s-1vcpu-1gb"
  region     = var.region
  node_count = 1
}
