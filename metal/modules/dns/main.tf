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

resource "proxmox_vm_qemu" "pihole" {
  name               = "pihole"
  tags               = "dns;tf"
  target_node        = var.proxmox_host
  clone              = var.cloud_init_template_name
  full_clone         = true
  vm_state           = "running"
  start_at_node_boot = true
  agent              = 1
  os_type            = "cloud-init"
  memory             = var.pihole_memory
  scsihw             = "virtio-scsi-pci"
  vmid               = 100

  cpu {
    cores = var.pihole_cores
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
          size    = var.pihole_disk_size
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

  ipconfig0 = "ip=${var.pihole_ip}/24,gw=${var.network_gateway}"

  ciuser  = "ops"
  sshkeys = var.ssh_keys
}

locals {
  fqdn = "dns.infra.home.arpa"
}

resource "ansible_host" "dns" {
  name   = local.fqdn
  groups = ["dns"]
  variables = {
    ansible_host = proxmox_vm_qemu.pihole.ssh_host
    ansible_user = "ops"
  }
}

resource "pihole_dns_record" "dns" {
  count = var.bootstrap ? 0 : 1

  domain = local.fqdn
  ip     = proxmox_vm_qemu.pihole.ssh_host
}
