terraform {
    required_providers {
      proxmox = {
        source = "telmate/proxmox"
        version = "2.9.14"
      }
    }
}

provider "proxmox" {
    pm_api_url = var.proxmox_api_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret
    pm_tls_insecure = var.proxmox_tls_insecure
}

module "k3s_leaders" {
    source = "./proxmox-cloud-init-vm"

    instances = var.k3s_leaders_amount
    instance_name = "k3s-leader"
    tags = "k3s;k3s-leader"

    proxmox_host = var.proxmox_host
    proxmox_resource_pool = var.k3s_resource_pool
    template_name = var.cloud_init_template_name
    vmid_start = var.k3s_leaders_vmid_start

    cores = var.k3s_leaders_cores
    memory = var.k3s_leaders_memory
    disk_size = var.k3s_leaders_disk_size
    storage = var.proxmox_storage

    ip_start = var.k3s_leaders_ip
    network_gateway = var.network_gateway
    ssh_key = var.ssh_key
}

module "k3s_workers" {
    source = "./proxmox-cloud-init-vm"

    instances = var.k3s_workers_amount
    instance_name = "k3s-worker"
    tags = "k3s;k3s-worker"

    proxmox_host = var.proxmox_host
    proxmox_resource_pool = var.k3s_resource_pool
    template_name = var.cloud_init_template_name
    vmid_start = var.k3s_workers_vmid_start

    cores = var.k3s_workers_cores
    memory = var.k3s_workers_memory
    disk_size = var.k3s_workers_disk_size
    storage = var.proxmox_storage

    ip_start = var.k3s_workers_ip
    network_gateway = var.network_gateway
    ssh_key = var.ssh_key
}

resource "local_file" "k3s_hosts_cfg" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      k3s_leaders = module.k3s_leaders.ssh_hosts
      k3s_workers = module.k3s_workers.ssh_hosts
    }
  )
  filename = "../playbooks/k3s/inventory/hosts.ini"
}