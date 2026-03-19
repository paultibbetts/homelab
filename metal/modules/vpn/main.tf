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
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

resource "proxmox_vm_qemu" "vpn" {
  name        = "vpn"
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
  vmid        = 300

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

  ipconfig0     = "ip=dhcp"
  skip_ipv6     = true
  agent_timeout = 180

  ciuser  = "ops"
  sshkeys = var.ssh_keys
}

locals {
  fqdn = "vpn.infra.home.arpa"
}

resource "ansible_host" "vpn" {
  name   = local.fqdn
  groups = ["vpn"]
  variables = {
    ansible_host = proxmox_vm_qemu.vpn.ssh_host
    ansible_user = "ops"
  }
}

resource "pihole_dns_record" "vpn" {
  domain = local.fqdn
  ip     = proxmox_vm_qemu.vpn.ssh_host
}

