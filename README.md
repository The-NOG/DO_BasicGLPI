# DO_BasicGLPI
Basic GLPI deployment to digital ocean via Terraform

## Tech Stack

### Terraform

Provisioning resources

### LAMP

* Ubunutu Linux
* Apache2
* MySQL (managed by DigitalOcean)
* PHP8

Using let's encrypt for TLS cert

## Terraform provision Resources

* Project to contain everything
* Droplet
* 100GB volume for config and files 
* DigitalOcean Managed Mysql DB (including firewall, user, and schema)
* DNS

## Articles and such

### Terraform

[DigitalOcean Terraform](https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean)

[Terraform DigitalOcean Ref](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)

[Terraform Templatefile Ref](https://developer.hashicorp.com/terraform/language/functions/templatefile)

### GLPI

[GLPI Install](https://glpi-install.readthedocs.io/en/latest/prerequisites.html#apache-configuration)

