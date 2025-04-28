output "ssh_hosts" {
  value = {
    leaders = proxmox_vm_qemu.leaders[*].ssh_host
    workers = proxmox_vm_qemu.workers[*].ssh_host
  }
}
