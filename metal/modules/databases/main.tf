terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

resource "proxmox_vm_qemu" "mysql" {
  name        = "mysql"
  tags        = "database"
  target_node = var.proxmox_host
  clone       = var.cloud_init_template_name
  full_clone  = true
  vm_state    = "running"
  onboot      = true
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.mysql_cores
  memory      = var.mysql_memory
  scsihw      = "virtio-scsi-pci"
  vmid        = 201

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
          size    = var.mysql_disk_size
          storage = var.proxmox_storage
          format  = "qcow2"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      qemu_os,
    ]
  }

  # cloud-init

  ipconfig0 = "ip=${var.mysql_ip}/24,gw=${var.network_gateway}"

  sshkeys = <<EOF
    ${var.ssh_keys}
    EOF
}

resource "local_file" "mysql_hosts" {
  content = templatefile("${path.root}/templates/host/hosts.tpl",
    {
      name = "mysql"
      ip   = proxmox_vm_qemu.mysql.ssh_host
      user = "ubuntu"
    }
  )
  filename = "../bootstrap/playbooks/mysql/inventory/hosts"
}

resource "proxmox_vm_qemu" "postgres" {
  name        = "postgres"
  tags        = "database"
  target_node = var.proxmox_host
  clone       = var.cloud_init_template_name
  full_clone  = true
  vm_state    = "running"
  onboot      = true
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.postgres_cores
  memory      = var.postgres_memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  vmid        = 202

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
          size    = var.postgres_disk_size
          storage = var.proxmox_storage
          format  = "qcow2"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      qemu_os,
    ]
  }

  # cloud-init

  ipconfig0 = "ip=${var.postgres_ip}/24,gw=${var.network_gateway}"

  sshkeys = <<EOF
    ${var.ssh_keys}
    EOF
}

resource "local_file" "postgres_hosts" {
  content = templatefile("${path.root}/templates/host/hosts.tpl",
    {
      name = "postgres"
      ip   = proxmox_vm_qemu.postgres.ssh_host
      user = "ubuntu"
    }
  )
  filename = "../bootstrap/playbooks/postgres/inventory/hosts"
}

