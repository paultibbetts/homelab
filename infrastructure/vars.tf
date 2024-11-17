## Provider

variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "If the API is insecure"
  type        = bool
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

# Global

variable "ssh_keys" {
  description = "The SSH keys to add"
  type        = string
  default     = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLiEeOqR0KLdVZ64p94nk2fSno1jyminStrv2OPVcd2 code@paultibbetts.uk
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfx70ArvHPF+9U3GgKgNEAWkXSyZMun83sn9582Pl4e code@paultibbetts.uk
    EOT
}

variable "network_gateway" {
  description = "The network gateway"
  type        = string
  default     = "192.168.1.1"
  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.network_gateway))
    error_message = "The network_gateway value must be a valid IP."
  }
}

# Proxmox

variable "proxmox_host" {
  description = "The proxmox host to apply to"
  type        = string
  default     = "host1"
}

variable "proxmox_storage" {
  description = "The storage on the host to use"
  type        = string
  default     = "vms"
}

# Proxmox cloud-init VM

variable "cloud_init_template_name" {
  description = "The cloud-init template to clone from"
  type        = string
  default     = "ubuntu-2404-cloudinit-template"
}

