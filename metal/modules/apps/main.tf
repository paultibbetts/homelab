terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc9"
    }
  }
}

resource "proxmox_vm_qemu" "apps" {
  name        = "apps"
  target_node = var.proxmox_host
  clone       = var.cloud_init_template_name
  full_clone  = true
  vm_state    = "running"
  onboot      = true
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.cores
  memory      = var.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  vmid        = 400

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

resource "ansible_host" "apps-0" {
  name   = proxmox_vm_qemu.apps.ssh_host
  groups = ["apps"]
  variables = {
    ansible_user = "ubuntu"
  }
}
