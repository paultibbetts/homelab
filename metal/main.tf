terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
  backend "s3" {
    bucket                      = "tfstate"
    key                         = "homelab.tfstate"
    region                      = "main" # region validation will be skipped
    skip_credentials_validation = true   # Skip AWS related checks and validations
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true # Enable path-style S3 URLs (https://<HOST>/<BUCKET> https://developer.hashicorp.com/terraform/language/settings/backends/s3#use_path_style
  }
}

module "dns" {
  source = "./modules/dns"

  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
}

module "databases" {
  source = "./modules/databases"

  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
}

module "gitea" {
  source = "./modules/gitea"

  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
}

module "ingress" {
  source = "./modules/ingress"

  ssh_keys        = var.ssh_keys
  network_gateway = var.network_gateway
  proxmox_storage = var.proxmox_storage
  proxmox_host    = var.proxmox_host
  lxc_template    = var.lxc_template
}

module "vpn" {
  source = "./modules/vpn"

  ssh_keys                 = var.ssh_keys
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
}

module "apps" {
  source = "./modules/apps"

  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
}

module "k3s" {
  source = "./modules/k3s"

  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
}

resource "local_file" "longhorn_hosts" {
  content = templatefile("${path.root}/templates/longhorn/hosts.tpl",
    {
      hosts = module.k3s.ssh_hosts.workers
    }
  )
  filename = "../bootstrap/playbooks/longhorn/inventory/hosts"
}
