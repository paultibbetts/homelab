variable "ssh_keys" {
  description = "The SSH keys to add"
  type        = string
}

variable "proxmox_storage" {
  description = "The storage on the host to use"
  type        = string
}

variable "proxmox_host" {
  description = "The host to use"
  type        = string
}

variable "lxc_template" {
  description = "The LXC template"
  type        = string
}

variable "memory" {
  description = "The amount of RAM"
  type        = number
  default     = 2048
}

variable "network_gateway" {
  description = "The network gateway"
  type        = string
}

variable "ip" {
  description = "The IP"
  type        = string
  default     = "192.168.1.9"
}

