resource "digitalocean_domain" "domain" {
  name = "${var.domain}.${var.tld}"
}

resource "digitalocean_record" "A-GLPI" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = var.host
  value  = digitalocean_droplet.web-1.ipv4_address
}

resource "digitalocean_project_resources" "dns" {
  project   = digitalocean_project.project.id
  resources = [
    digitalocean_domain.domain.urn
  ]
}