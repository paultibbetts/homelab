terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
}

resource "ansible_host" "deskpi" {
  name   = "192.168.1.133"
  groups = ["deskpi", "pi"]
  variables = {
    ansible_user = "paul"
  }
}
