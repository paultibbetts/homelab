# Global

variable "ssh_keys" {
    description = "The SSH keys to add"
    type = string
    default = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLiEeOqR0KLdVZ64p94nk2fSno1jyminStrv2OPVcd2 code@paultibbetts.uk
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfx70ArvHPF+9U3GgKgNEAWkXSyZMun83sn9582Pl4e code@paultibbetts.uk
    EOT
}

variable "network_gateway" {
    description = "The network gateway"
    type = string
    default = "192.168.1.1"
    validation {
        condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.network_gateway))
        error_message = "The network_gateway value must be a valid IP."
    }
}

# Proxmox

variable "proxmox_host" {
    description = "The proxmox host to apply to"
    type = string
    default = "host1"
}

variable "proxmox_storage" {
    description = "The storage on the host to use"
    type = string
    default = "vms"
}

## Provider

variable "proxmox_api_url" {
    description = "Proxmox API URL"
    type = string
    sensitive = true
}

variable "proxmox_tls_insecure" {
    description = "If the API is insecure"
    type = bool
}

variable "proxmox_api_token_id" {
    description = "Proxmox API token ID"
    type = string
    sensitive = true
}

variable proxmox_api_token_secret {
    description = "Proxmox API token secret"
    type = string
    sensitive = true
}

# Proxmox cloud-init VM

variable "cloud_init_template_name" {
    description = "The cloud-init template to clone from"
    type = string
    default = "ubuntu-22-04-cloudinit-template"
}

# K3s

variable "k3s_resource_pool" {
    description = "The resource pool to use for K3s VMs"
    type = string
    default = "k3s"
}

## K3s Leaders
variable "k3s_leaders_amount" {
    description = "How many K3s leaders"
    type = number
    default = 3
}

variable "k3s_leaders_vmid_start" {
    description = "The starting number for K3s leaders VM IDs"
    type = number
    default = 301
}

variable "k3s_leaders_cores" {
    description = "How many cores for K3s leaders"
    type = number
    default = 2
}

variable "k3s_leaders_memory" {
    description = "How much RAM for K3s leaders"
    type = number
    default = 4096
}

variable "k3s_leaders_disk_size" {
    description = "How much disk size for K3s leaders"
    type = string
    default = "10G"
}

variable "k3s_leaders_ip_start" {
    description = "The starting point for K3s leaders IPs"
    type = string
    default = "192.168.1.22" # + "${count.index}"
}

## K3s Workers

variable "k3s_workers_amount" {
    description = "How many K3s workers"
    type = number
    default = 2
}

variable "k3s_workers_vmid_start" {
    description = "The starting number for K3s workers VM IDs"
    type = number
    default = 311
}

variable "k3s_workers_cores" {
    description = "How many cores for K3s workers"
    type = number
    default = 2
}

variable "k3s_workers_memory" {
    description = "How much RAM for K3s workers"
    type = number
    default = 4096
}

variable "k3s_workers_disk_size" {
    description = "How much disk size for K3s workers"
    type = string
    default = "10G"
}

variable "k3s_workers_ip_start" {
    description = "The starting point for K3s workers IPs"
    type = string
    default = "192.168.1.23" # + "${count.index}"
}

## K3s Storers

variable "k3s_storers_amount" {
    description = "How many K3s storers"
    type = number
    default = 1
}

variable "k3s_storers_vmid_start" {
    description = "The starting number for K3s storers VM IDs"
    type = number
    default = 321
}

variable "k3s_storers_cores" {
    description = "How many cores for K3s storers"
    type = number
    default = 1
}

variable "k3s_storers_memory" {
    description = "How much RAM for K3s storers"
    type = number
    default = 2048
}

variable "k3s_storers_disk_size" {
    description = "How much disk size for K3s storers"
    type = string
    default = "100G"
}

variable "k3s_storers_ip_start" {
    description = "The starting point for K3s storers IPs"
    type = string
    default = "192.168.1.24" # + "${count.index}"
}

# MySQL

variable "mysql_disk_size" {
    description = "How much disk size for MySQL"
    type = string
    default = "10G"
}

variable "mysql_cores" {
    description = "How many cores for MySQL"
    type = number
    default = 1
}

variable "mysql_memory" {
    description = "The amount of RAM for MySQL"
    type = number
    default = 4096
}

variable "mysql_vmid_start" {
    description = "The number for MySQL VM ID"
    type = number
    default = 201
}

variable "mysql_ip" {
  description = "The starting point for MySQL IPs"
  type = string
  default = "192.168.1.201"
}


# Gitea

variable "gitea_disk_size" {
    description = "How much disk size for Gitea"
    type = string
    default = "100G"
}

variable "gitea_cores" {
    description = "How many cores for Gitea"
    type = number
    default = 1
}

variable "gitea_memory" {
    description = "The amount of RAM for Gitea"
    type = number
    default = 2048
}

variable "gitea_vmid_start" {
    description = "The number for Gitea VM ID"
    type = number
    default = 201
}

variable "gitea_ip" {
  description = "The IP for Gitea"
  type = string
  default = "192.168.1.211"
}
