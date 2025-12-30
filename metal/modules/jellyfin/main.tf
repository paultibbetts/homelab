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
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc05"
    }
  }
}

resource "proxmox_lxc" "jellyfin" {
  hostname    = "jellyfin"
  target_node = var.proxmox_host
  vmid        = 302

  unprivileged = var.unprivileged
  start        = true
  onboot       = true
  memory       = var.memory
  swap         = 2048
  cores        = var.cores
  nameserver   = var.pihole_ip

  ostemplate = var.lxc_template

  features {
    nesting = true
  }

  ssh_public_keys = <<EOF
  ${var.ssh_keys}
  EOF

  rootfs {
    storage = var.proxmox_storage
    size    = "100G"
  }

  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = "${var.ip}/24"
    ip6      = "auto"
    gw       = var.network_gateway
    firewall = true
  }

  mountpoint {
    key     = "0"
    slot    = "0"
    storage = "/mnt/nas"
    volume  = "/mnt/nas"
    mp      = "/mnt/nas-media"
    size    = var.nas_mp_size
    backup  = false
    shared  = false
  }

  mountpoint {
    key     = "1"
    slot    = "1"
    storage = "/dev/dri/renderD128"
    volume  = "/dev/dri/renderD128"
    mp      = "/dev/dri/renderD128"
    size    = "1G" # required by provider, ignored
  }

  lifecycle {
    # the LXC was originally created manually
    prevent_destroy = true

    ignore_changes = [
      rootfs,          # this would force a new LXC
      ssh_public_keys, # this would force a new LXC
      cmode,           # not worth managing with Terraform
      ostemplate,      # this LXC was created before and imported into TF
      mountpoint,      # only changeable by root@pam - use TF to create the LXC and edit manually I guess?
    ]
  }

}

locals {
  fqdn = "jellyfin.infra.home.arpa"
}

resource "ansible_host" "jellyfin" {
  name   = local.fqdn
  groups = ["jellyfin"]
  variables = {
    ansible_host = var.ip
    ansible_user = "root"
  }
}

resource "pihole_dns_record" "jellyfin" {
  domain = local.fqdn
  ip     = var.ip
}

