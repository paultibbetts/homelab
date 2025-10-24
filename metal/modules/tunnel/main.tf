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

  ipconfig0     = "ip=dhcp"
  skip_ipv6     = true
  agent_timeout = 180

  sshkeys = var.ssh_keys
}

// add Pi here
// import it

resource "ansible_host" "newt-0" {
  name   = "192.168.1.149"
  groups = ["tunnel", "newt"]
  variables = {
    ansible_user = "ubuntu"
  }
}

resource "ansible_host" "pangolin-0" {
  name   = "ssh.pangolin.hostedpi.com"
  groups = ["tunnel", "pangolin"]
  variables = {
    ansible_user = "ansible"
    ansible_port = 5310
  }
}
