resource "digitalocean_domain" "boontouick" {
  name = "boontouick.com"
}

resource "digitalocean_record" "CNAME-www" {
  domain = digitalocean_domain.boontouick.name
  type   = "A"
  name   = "glpi"
  value  = digitalocean_droplet.web-1.ipv4_address
}

resource "digitalocean_project_resources" "dns" {
  project   = digitalocean_domain.boontouick.id
  resources = [
    digitalocean_domain.boontouick.urn
  ]
}