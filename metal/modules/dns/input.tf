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
  description = "The cloud-init template name"
  type        = string
}

variable "pihole_disk_size" {
  description = "How much disk size for pihole"
  type        = string
  default     = "10G"
}

variable "pihole_cores" {
  description = "How many cores for pihole"
  type        = number
  default     = 1
}

variable "pihole_memory" {
  description = "The amount of RAM for pihole"
  type        = number
  default     = 4096
}

variable "pihole_ip" {
  description = "The starting point for pihole IPs"
  type        = string
  default     = "192.168.1.2"
}

variable "bootstrap" {
  description = "Is this the first run?"
  type        = bool
  default     = false
}
