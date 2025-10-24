variable "ssh_keys" {
  description = "SSH keys to add"
  type        = string
}

variable "proxmox_storage" {
  description = "Storage on the host to use (e.g., local-lvm)"
  type        = string
}

variable "proxmox_host" {
  description = "Proxmox node name (e.g., pve)"
  type        = string
}

variable "lxc_template" {
  description = "LXC template (only used for fresh creates)"
  type        = string
  default     = null
}

variable "memory" {
  description = "RAM (MB)"
  type        = number
  default     = 8192
}

variable "network_gateway" {
  description = "IPv4 gateway"
  type        = string
}

variable "ip" {
  description = "IPv4 address (no CIDR)"
  type        = string
  default     = "192.168.1.6"
}

variable "cores" {
  description = "vCPU cores"
  type        = number
  default     = 2
}

variable "unprivileged" {
  description = "Run container unprivileged"
  type        = bool
  default     = true
}

# Bind mount sizing is 'read only' in Proxmox, but provider requires a value.
variable "nas_mp_size" {
  description = "Dummy size for bind mount (ignored by Proxmox)"
  type        = string
  default     = "256G"
}

variable "pihole_ip" {
  description = "The IP of Pi-hole, to use as the nameserver"
  type = string
  default = "192.168.1.2"
}
