resource "digitalocean_database_cluster" "mysql-glpi" {
  name       = "glpi-mysql-cluster"
  engine     = "mysql"
  version    = "8"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc1"
  node_count = 1
}
resource "digitalocean_database_user" "glpi-user" {
  cluster_id = digitalocean_database_cluster.mysql-glpi.id
  name       = var.glpi_db_user
}

output "db_pass" {
  value = digitalocean_database_user.glpi-user.password
  sensitive = true
}

resource "digitalocean_database_firewall" "glpi-fw" {
  cluster_id = digitalocean_database_cluster.mysql-glpi.id

  rule {
    type  = "droplet"
    value = digitalocean_droplet.web-1.id
  }
}
resource "digitalocean_project_resources" "db" {
  project = digitalocean_domain.boontouick.id
  resources = [
    digitalocean_database_cluster.mysql-glpi.urn
  ]
}