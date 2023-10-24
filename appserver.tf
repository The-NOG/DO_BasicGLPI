resource "digitalocean_droplet" "web-1" {
  image    = "ubuntu-22-04-x64"
  name     = "NYC3-web-1"
  region   = "nyc3"
  size     = "s-2vcpu-4gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  user_data = templatefile("Scripts/Deployment.sh", {
    host = var.host, domain = var.domain, tld = var.tld,db_host = digitalocean_database_cluster.mysql-glpi.host,db_port=digitalocean_database_cluster.mysql-glpi.port,db_user=var.glpi_db_user,db_password=digitalocean_database_user.glpi-user.password,db_schema=var.glpi_db_schema
  })
}
resource "digitalocean_volume" "glpi-data" {
  region                  = "nyc3"
  name                    = "data"
  size                    = 100
  initial_filesystem_type = "ext4"
  description             = "Data for glpi"
}
resource "digitalocean_volume_attachment" "glpi-data" {
  droplet_id = digitalocean_droplet.web-1.id
  volume_id  = digitalocean_volume.glpi-data.id
}
resource "digitalocean_project_resources" "web-1" {
  project = digitalocean_project.project.id
  resources = [
    digitalocean_droplet.web-1.urn
  ]
}