terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure
}

module "k3s_leaders" {
  source = "./proxmox-cloud-init-vm"

  instances     = var.k3s_leaders_amount
  instance_name = "k3s-leader"
  tags          = "k3s;k3s-leader"

  proxmox_host          = var.proxmox_host
  proxmox_resource_pool = var.k3s_resource_pool
  template_name         = var.cloud_init_template_name
  vmid_start            = var.k3s_leaders_vmid_start

  cores     = var.k3s_leaders_cores
  memory    = var.k3s_leaders_memory
  disk_size = var.k3s_leaders_disk_size
  storage   = var.proxmox_storage

  ip_start        = var.k3s_leaders_ip_start
  network_gateway = var.network_gateway
  ssh_keys        = var.ssh_keys
}

module "k3s_workers" {
  source = "./proxmox-cloud-init-vm"

  instances     = var.k3s_workers_amount
  instance_name = "k3s-worker"
  tags          = "k3s;k3s-worker"

  proxmox_host          = var.proxmox_host
  proxmox_resource_pool = var.k3s_resource_pool
  template_name         = var.cloud_init_template_name
  vmid_start            = var.k3s_workers_vmid_start

  cores     = var.k3s_workers_cores
  memory    = var.k3s_workers_memory
  disk_size = var.k3s_workers_disk_size
  storage   = var.proxmox_storage

  ip_start        = var.k3s_workers_ip_start
  network_gateway = var.network_gateway
  ssh_keys        = var.ssh_keys
}

resource "local_file" "k3s_hosts_cfg" {
  content = templatefile("${path.module}/templates/k3s/hosts.tpl",
    {
      k3s_leaders = module.k3s_leaders.ssh_hosts
      k3s_workers = module.k3s_workers.ssh_hosts
    }
  )
  filename = "../playbooks/k3s/inventory/cluster/hosts"
}

module "mysql" {
  source = "./proxmox-cloud-init-vm"

  instances     = 1
  instance_name = "mysql"
  tags          = "database;mysql"

  proxmox_host  = var.proxmox_host
  template_name = var.cloud_init_template_name
  vmid_start    = var.mysql_vmid_start

  cores     = var.mysql_cores
  memory    = var.mysql_memory
  disk_size = var.mysql_disk_size
  storage   = var.proxmox_storage

  ip              = var.mysql_ip
  network_gateway = var.network_gateway
  ssh_keys        = var.ssh_keys
}

resource "local_file" "mysql_hosts_cfg" {
  content = templatefile("${path.module}/templates/single-vm/hosts.tpl",
    {
      name = "mysql"
      ips  = module.mysql.ssh_hosts
    }
  )
  filename = "../playbooks/mysql/inventory/hosts"
}

module "postgres" {
  source = "./proxmox-cloud-init-vm"

  instances     = 1
  instance_name = "postgres"
  tags          = "database;postgres"

  proxmox_host  = var.proxmox_host
  template_name = var.cloud_init_template_name
  vmid_start    = var.postgres_vmid_start

  cores     = var.postgres_cores
  memory    = var.postgres_memory
  disk_size = var.postgres_disk_size
  storage   = var.proxmox_storage

  ip              = var.postgres_ip
  network_gateway = var.network_gateway
  ssh_keys        = var.ssh_keys
}

resource "local_file" "postgres_hosts_cfg" {
  content = templatefile("${path.module}/templates/single-vm/hosts.tpl",
    {
      name = "postgres"
      ips  = module.postgres.ssh_hosts
    }
  )
  filename = "../playbooks/postgres/inventory/hosts"
}

module "gitea" {
  source = "./proxmox-cloud-init-vm"

  instances     = 1
  instance_name = "gitea"
  tags          = "gitea"

  proxmox_host  = var.proxmox_host
  template_name = var.cloud_init_template_name
  vmid_start    = 211

  cores     = var.gitea_cores
  memory    = var.gitea_memory
  disk_size = var.gitea_disk_size
  storage   = var.proxmox_storage

  ip              = var.gitea_ip
  network_gateway = var.network_gateway
  ssh_keys        = var.ssh_keys
}

resource "local_file" "gitea_hosts_cfg" {
  content = templatefile("${path.module}/templates/single-vm/hosts.tpl",
    {
      name = "gitea"
      ips  = module.gitea.ssh_hosts
    }
  )
  filename = "../playbooks/gitea/inventory/hosts"
}

