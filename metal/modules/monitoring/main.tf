terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
    pihole = {
      source  = "lukaspustina/pihole"
      version = "0.3.1"
    }
  }
}

locals {
  fqdn = "monpi.infra.home.arpa"
  ip   = "192.168.1.133"
}

resource "ansible_host" "monpi" {
  name   = local.fqdn
  groups = ["monpi", "pi"]
  variables = {
    ansible_host = local.ip
    ansible_user = "ops"
  }
}

resource "pihole_dns_record" "monpi" {
  domain = local.fqdn
  ip     = local.ip
}

