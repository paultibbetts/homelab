resource "proxmox_vm_qemu" "newt" {
  name               = "newt"
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
  vmid               = 304

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

  ipconfig0  = "ip=192.168.1.149/24,gw=192.168.1.1"
  nameserver = "192.168.1.2"

  ciuser  = "ops"
  sshkeys = var.ssh_keys
}

resource "hcloud_primary_ip" "edge" {
  name          = "pangolin"
  location      = "nbg1"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
}

locals {
  ops_pubkey = trimspace(var.ssh_key)
}

resource "hcloud_server" "edge" {
  name        = "pangolin"
  image       = "ubuntu-24.04"
  server_type = "cax11" # cheapest ARM
  location    = "nbg1"  # Nuremberg
  user_data = templatefile("${path.root}/bootstrap/cloud-init.ubuntu24.tftpl", {
    ops_pubkey = local.ops_pubkey
  })
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
    ipv4         = hcloud_primary_ip.edge.id
  }
}
