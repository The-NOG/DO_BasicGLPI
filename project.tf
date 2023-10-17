
resource "digitalocean_project" "project" {
  name        = "${var.domain} GLPI"
  description = "GLPI for ${var.domain}"
  purpose     = "Web Application"
  environment = "Production"
}