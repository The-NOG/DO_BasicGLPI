
resource "digitalocean_project" "boontouickGLPI" {
  name        = "Boontouick GLPI"
  description = "GLPI for Boontouick"
  purpose     = "Web Application"
  environment = "Production"
}