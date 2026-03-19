terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.4.0"
    }
    pihole = {
      source  = "lukaspustina/pihole"
      version = "0.3.1"
    }
  }
}

locals {
  fqdn = "artpi.infra.home.arpa"
  ip   = "192.168.1.132"
}

resource "ansible_host" "artpi" {
  name   = local.fqdn
  groups = ["pi"]
  variables = {
    ansible_host = local.ip
    ansible_user = "pi"
  }
}

resource "pihole_dns_record" "artpi" {
  domain = local.fqdn
  ip     = local.ip
}

