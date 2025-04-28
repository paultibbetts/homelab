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

variable "mysql_disk_size" {
  description = "How much disk size for MySQL"
  type        = string
  default     = "10G"
}

variable "mysql_cores" {
  description = "How many cores for MySQL"
  type        = number
  default     = 1
}

variable "mysql_memory" {
  description = "The amount of RAM for MySQL"
  type        = number
  default     = 4096
}

variable "mysql_ip" {
  description = "The starting point for MySQL IPs"
  type        = string
  default     = "192.168.1.201"
}

variable "postgres_disk_size" {
  description = "How much disk size for Postgres"
  type        = string
  default     = "10G"
}

variable "postgres_cores" {
  description = "How many cores for Postgres"
  type        = number
  default     = 1
}

variable "postgres_memory" {
  description = "The amount of RAM for Postgres"
  type        = number
  default     = 4096
}

variable "postgres_ip" {
  description = "The starting point for Postgres IPs"
  type        = string
  default     = "192.168.1.202"
}


