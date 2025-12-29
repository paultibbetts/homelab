terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
}

resource "ansible_host" "deskpi" {
  name   = "deskpi.infra.home.arpa"
  groups = ["deskpi", "pi"]
  variables = {
    ansible_host = "192.168.1.133"
    ansible_user = "paul"
  }
}
