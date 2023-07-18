# Global

variable "ssh_key" {
    description = "The SSH key to add"
    type = string
    default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLiEeOqR0KLdVZ64p94nk2fSno1jyminStrv2OPVcd2 code@paultibbetts.uk"
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

# K3S

variable "k3s_resource_pool" {
    description = "The resource pool to use for K3S VMs"
    type = string
    default = "k3s"
}

## Leaders
variable "k3s_leaders_amount" {
    description = "How many K3S leaders"
    type = number
    default = 3
}

variable "k3s_leaders_vmid_start" {
    description = "The starting number for K3S leaders VM IDs"
    type = number
    default = 201
}

variable "k3s_leaders_cores" {
    description = "How many cores for K3S leaders"
    type = number
    default = 2
}

variable "k3s_leaders_memory" {
    description = "How much RAM for K3S leaders"
    type = number
    default = 2048
}

variable "k3s_leaders_disk_size" {
    description = "How much disk size for K3S leaders"
    type = string
    default = "10G"
}

variable "k3s_leaders_ip" {
    description = "The starting point for K3S leaders IPs"
    type = string
    default = "192.168.1.20" # + "${count.index}"
}

## Workers

variable "k3s_workers_amount" {
    description = "How many K3S workers"
    type = number
    default = 2
}

variable "k3s_workers_vmid_start" {
    description = "The starting number for K3S workers VM IDs"
    type = number
    default = 211
}

variable "k3s_workers_cores" {
    description = "How many cores for K3S workers"
    type = number
    default = 2
}

variable "k3s_workers_memory" {
    description = "How much RAM for K3S workers"
    type = number
    default = 2048
}

variable "k3s_workers_disk_size" {
    description = "How much disk size for K3S workers"
    type = string
    default = "10G"
}

variable "k3s_workers_ip" {
    description = "The starting point for K3S workers IPs"
    type = string
    default = "192.168.1.21" # + "${count.index}"
}