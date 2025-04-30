terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

resource "proxmox_lxc" "caddy" {
  hostname     = "ingress"
  target_node  = var.proxmox_host
  ostemplate   = var.lxc_template
  unprivileged = true
  vmid         = 303
  start        = true
  onboot       = true
  memory       = var.memory
  cores        = 1

  ssh_public_keys = <<EOT
		${var.ssh_keys}
		EOT

  rootfs {
    storage = var.proxmox_storage
    size    = "10G"
  }

  network {
    name     = "eth0"
    bridge   = "vmbr0"
    gw       = var.network_gateway
    ip       = "${var.ip}/24"
    firewall = true
  }
}

resource "local_file" "hosts" {
  content = templatefile("${path.root}/templates/host/hosts.tpl",
    {
      name = "ingress"
      ip   = var.ip
      user = "root"
    }
  )
  filename = "../bootstrap/playbooks/ingress/inventory/hosts"
}
