terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc05"
    }
  }
}

resource "proxmox_vm_qemu" "ingress" {
  name        = "ingress"
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
  vmid        = 303

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

  ipconfig0 = "ip=${var.ip}/24,gw=${var.network_gateway}"

  sshkeys = <<EOF
	${var.ssh_keys}
	EOF
}

resource "ansible_host" "ingress-0" {
  name   = proxmox_vm_qemu.ingress.ssh_host
  groups = ["ingress"]
  variables = {
    ansible_user = "ubuntu"
  }
}


