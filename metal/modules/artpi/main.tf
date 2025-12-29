terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
}

resource "ansible_host" "artpi" {
  name   = "artpi.infra.home.arpa"
  groups = ["pi"]
  variables = {
    ansible_host = "192.168.1.132"
    ansible_user = "pi"
  }
}
