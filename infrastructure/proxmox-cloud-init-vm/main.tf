terraform {
    required_providers {
      proxmox = {
        source = "telmate/proxmox"
        version = ">= 2.9.14"
      }
    }
}

resource "proxmox_vm_qemu" "proxmox_cloud-init_vm" {
    count = var.instances
    name = "${var.instance_name}-${count.index + 1}"
    tags = var.tags

    target_node = var.proxmox_host
    pool = var.proxmox_resource_pool

    clone = var.template_name
    full_clone = true

    vmid = "${format("%g", count.index + var.vmid_start)}"

    oncreate = true
    agent = 1
    os_type = "cloud-init"
    cores = var.cores
    sockets = 1
    cpu = "host"
    memory = var.memory

    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    disk {
        slot = 0
        size = var.disk_size
        type = "scsi"
        storage = var.storage
    }

    network {
        model = "virtio"
        bridge = "vmbr0"
    }

    lifecycle {
        ignore_changes = [
            qemu_os,
         ]
    }

    # cloud-init

    ipconfig0 = "ip=${var.ip_start}${count.index + 1}/24,gw=${var.network_gateway}"

    sshkeys = <<EOF
    ${var.ssh_keys}
    EOF
}