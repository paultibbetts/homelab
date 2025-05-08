variable "ssh_keys" {
  description = "The SSH keys to add"
  type        = string
}

variable "network_gateway" {
  description = "The network gateway"
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

variable "cloud_init_template_name" {
  description = "The cloud-init template"
  type        = string
}

variable "disk_size" {
  description = "How much disk size for apps"
  type        = string
  default     = "100G"
}

variable "cores" {
  description = "How many cores for apps"
  type        = number
  default     = 1
}
variable "memory" {
  description = "The amount of RAM"
  type        = number
  default     = 2048
}


variable "ip" {
  description = "The IP"
  type        = string
  default     = "192.168.1.10"
}

