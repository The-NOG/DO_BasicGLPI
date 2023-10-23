resource "digitalocean_droplet" "web-1" {
  image    = "ubuntu-22-04-x64"
  name     = "NYC3-web-1"
  region   = "nyc3"
  size     = "s-2vcpu-4gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  user_data = templatefile("web-1.yaml", { 
    ansible_user = var.ansible_user,
    ansible_public_key = var.ansible_public_key,
    bootstrapdir = var.bootstrapdir,
    bootstraprepo = var.bootstraprepo
    puppetrepo = var.puppetrepo })
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