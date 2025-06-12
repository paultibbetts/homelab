terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
}

resource "ansible_host" "artpi" {
  name   = "192.168.1.132"
  groups = ["pi"]
  variables = {
    ansible_user = "pi"
  }
}
