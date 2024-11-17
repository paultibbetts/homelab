variable "resource_pool" {
  description = "The resource pool to use for K3s VMs"
  type        = string
  default     = "k3s"
}

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

variable "leaders_amount" {
  description = "How many K3s leaders"
  type        = number
  default     = 3
}

variable "leaders_cores" {
  description = "How many cores for K3s leaders"
  type        = number
  default     = 2
}

variable "leaders_memory" {
  description = "How much RAM for K3s leaders"
  type        = number
  default     = 4096
}

variable "leaders_disk_size" {
  description = "How much disk size for K3s leaders"
  type        = string
  default     = "10G"
}

variable "leaders_ip_start" {
  description = "The starting point for K3s leaders IPs"
  type        = string
  default     = "192.168.1.22" # + "${count.index}"
}

variable "leaders_vmid_start" {
  description = "The starting point for K3s leaders VMIDs"
  type        = number
  default     = 311
}


## Workers

variable "workers_amount" {
  description = "How many K3s workers"
  type        = number
  default     = 3
}

variable "workers_cores" {
  description = "How many cores for K3s workers"
  type        = number
  default     = 2
}


variable "workers_memory" {
  description = "How much RAM for K3s workers"
  type        = number
  default     = 4096
}

variable "workers_disk_size" {
  description = "How much disk size for K3s workers"
  type        = string
  default     = "50G"
}

variable "workers_storage_disk_size" {
  description = "How much disk size for the storage disk for K3s workers"
  type        = string
  default     = "100G"
}

variable "workers_ip_start" {
  description = "The starting point for K3s workers IPs"
  type        = string
  default     = "192.168.1.23" # + "${count.index}"
}

variable "workers_vmid_start" {
  description = "The starting point for K3s workers VMIDs"
  type        = number
  default     = 321
}
