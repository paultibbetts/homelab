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
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

resource "proxmox_vm_qemu" "apps" {
  name               = "apps"
  tags               = "tf"
  target_node        = var.proxmox_host
  clone              = var.cloud_init_template_name
  full_clone         = true
  vm_state           = "running"
  start_at_node_boot = true
  agent              = 1
  os_type            = "cloud-init"
  memory             = var.memory
  scsihw             = "virtio-scsi-pci"
  bootdisk           = "scsi0"
  vmid               = 400

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
      startup_shutdown,
    ]
  }

  # cloud-init

  ipconfig0 = "ip=${var.ip}/24,gw=${var.network_gateway}"

  ciuser  = "ops"
  sshkeys = var.ssh_keys
}

locals {
  fqdn = "apps.infra.home.arpa"
}

resource "ansible_host" "apps" {
  name   = local.fqdn
  groups = ["apps"]
  variables = {
    ansible_host = proxmox_vm_qemu.apps.ssh_host
    ansible_user = "ops"
  }
}

resource "pihole_dns_record" "apps" {
  domain = local.fqdn
  ip     = proxmox_vm_qemu.apps.ssh_host
}
