output "ssh_hosts" {
    value = proxmox_vm_qemu.proxmox_cloud-init_vm[*].ssh_host
}