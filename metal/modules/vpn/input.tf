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

variable "cloud_init_template_name" {
  description = "The cloud-init template name"
  type        = string
}

variable "disk_size" {
  description = "How much disk size"
  type        = string
  default     = "10G"
}

variable "cores" {
  description = "How many cores"
  type        = number
  default     = 1
}

variable "memory" {
  description = "The amount of RAM"
  type        = number
  default     = 2048
}

