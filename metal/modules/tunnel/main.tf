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

resource "proxmox_vm_qemu" "newt" {
  name        = "newt"
  tags        = "tf"
  target_node = var.proxmox_host
  clone       = var.cloud_init_template_name
  full_clone  = true
  vm_state    = "running"
  onboot      = true
  agent       = 1
  os_type     = "cloud-init"
  memory      = var.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  vmid        = 304

  cpu {
    cores = var.cores
  }

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = var.proxmox_storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.disk_size
          storage = var.proxmox_storage
          format  = "qcow2"
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      qemu_os,
    ]
  }

  # cloud-init

  ipconfig0  = "ip=192.168.1.149/24,gw=192.168.1.1"
  nameserver = "192.168.1.2"

  ciuser  = "ops"
  sshkeys = var.ssh_keys
}

// add Pi here
// import it

locals {
  home = {
    fqdn = "tunnel.infra.home.arpa"
    ip   = "192.168.1.149"
  }
  edge = {
    fqdn = "pangolin.hostedpi.com"
    host = "ssh.pangolin.hostedpi.com"
    port = 5310
  }
}

resource "ansible_host" "home" {
  name   = local.home.fqdn
  groups = ["tunnel", "site_home"]
  variables = {
    ansible_host = local.home.ip
    ansible_user = "ops"
  }
}

resource "pihole_dns_record" "home" {
  domain = local.home.fqdn
  ip     = local.home.ip
}

resource "ansible_host" "edge" {
  name   = local.edge.fqdn
  groups = ["tunnel", "site_edge"]
  variables = {
    ansible_host = local.edge.host
    ansible_user = "ansible"
    ansible_port = local.edge.port
  }
}

