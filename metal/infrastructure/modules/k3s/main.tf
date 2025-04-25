terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

resource "proxmox_vm_qemu" "leaders" {
  count       = var.leaders_amount
  name        = "k3s-leader-${count.index + 1}"
  tags        = "k3s;k3s-leader"
  target_node = var.proxmox_host
  #pool        = var.resource_pool
  clone      = var.cloud_init_template_name
  full_clone = true
  vm_state   = "running"
  onboot     = true
  agent      = 1
  os_type    = "cloud-init"
  cores      = var.leaders_cores
  memory     = var.leaders_memory
  scsihw     = "virtio-scsi-pci"
  bootdisk   = "scsi0"
  vmid       = format("%g", count.index + var.leaders_vmid_start)

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
          size    = var.leaders_disk_size
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

  ipconfig0 = "ip=${var.leaders_ip_start}${count.index}/24,gw=${var.network_gateway}"

  sshkeys = <<EOF
    ${var.ssh_keys}
    EOF
}

resource "proxmox_vm_qemu" "workers" {
  count       = var.workers_amount
  name        = "k3s-worker-${count.index + 1}"
  tags        = "k3s;k3s-worker"
  target_node = var.proxmox_host
  #pool        = var.resource_pool
  clone      = var.cloud_init_template_name
  full_clone = true
  vm_state   = "running"
  onboot     = true
  agent      = 1
  os_type    = "cloud-init"
  cores      = var.workers_cores
  memory     = var.workers_memory
  scsihw     = "virtio-scsi-pci"
  bootdisk   = "scsi0"
  vmid       = format("%g", count.index + var.workers_vmid_start)

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
          size    = var.workers_disk_size
          storage = var.proxmox_storage
          format  = "qcow2"
        }
      }
      scsi1 {
        disk {
          size    = var.workers_storage_disk_size
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

  ipconfig0 = "ip=${var.workers_ip_start}${count.index}/24,gw=${var.network_gateway}"

  sshkeys = <<EOF
    ${var.ssh_keys}
    EOF
}

resource "local_file" "hosts" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      leaders = proxmox_vm_qemu.leaders[*].ssh_host
      workers = proxmox_vm_qemu.workers[*].ssh_host
    }
  )
  filename = "../playbooks/k3s/inventory/cluster/hosts"
}

