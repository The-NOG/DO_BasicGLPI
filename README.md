# DO_BasicGLPI
Basic GLPI deployment to digital ocean via Terraform

## Tech Stack

### Terraform

Provisioning resources

### Cloud-Init

Used to prep for ansible, drop off important variables, and bootstrap puppet

### LAMP

* Ubunutu Linux
* Apache2
* MySQL (managed by DigitalOcean)
* PHP8

Using let's encrypt for TLS cert

### Puppet

Used for configuration management

### Ansible

Sets up server for management through ansible. Mostly because updates through puppet aren't fun IMHO

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

### CloudInit

[Cloud Init Examples](https://cloudinit.readthedocs.io/en/latest/reference/examples.html)

### Puppet

[Puppet Install docs](https://www.puppet.com/docs/puppet/8/install_puppet.html)

[Headless Puppet](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-masterless-puppet-environment-on-ubuntu-14-04)

### GLPI

[GLPI Install](https://glpi-install.readthedocs.io/en/latest/prerequisites.html#apache-configuration)

