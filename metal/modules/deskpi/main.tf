terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
    pihole = {
      source  = "lukaspustina/pihole"
      version = "0.3.0"
    }
  }
}

locals {
  fqdn = "deskpi.infra.home.arpa"
  ip   = "192.168.1.133"
}

resource "ansible_host" "deskpi" {
  name   = local.fqdn
  groups = ["deskpi", "pi"]
  variables = {
    ansible_host = local.ip
    ansible_user = "paul"
  }
}

resource "pihole_dns_record" "deskpi" {
  domain = local.fqdn
  ip     = local.ip
}

