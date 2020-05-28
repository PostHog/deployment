resource "digitalocean_database_firewall" "example-fw" {
  cluster_id = digitalocean_database_cluster.postgres-posthog.id

  rule {
    type  = "droplet"
    value = digitalocean_droplet.posthog-1.id
  }
}

resource "digitalocean_database_db" "database-posthog" {
  cluster_id = digitalocean_database_cluster.postgres-posthog.id
  name       = "posthog"
}

resource "digitalocean_database_user" "user-example" {
  cluster_id = digitalocean_database_cluster.postgres-posthog.id
  name       = "posthog"
}

resource "digitalocean_database_cluster" "postgres-posthog" {
  name       = "posthog-postgres-cluster"
  engine     = "pg"
  version    = "11"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc1"
  node_count = 1
}
