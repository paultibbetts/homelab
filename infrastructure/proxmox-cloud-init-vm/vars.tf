variable "instances" {
    description = "The number of instances"
    type = number
}

variable "instance_name" {
    description = "The name of the instance"
    type = string
}

variable "tags" {
    description = "Proxmox tags to apply (like;this)"
    type = string
    default = ""
}

variable "proxmox_host" {
    description = "The proxmox host to apply to"
    type = string
}

variable "proxmox_resource_pool" {
    description = "The resource pool name to use in Proxmox for organisation"
    type = string
    default = ""
}

variable "template_name" {
    description = "The cloud-init template to clone from"
    type = string
}

variable "vmid_start" {
    description = "The starting number for VM ID"
    type = number
}

variable "cores" {
    description = "The number of cores"
    type = number
    default = 1
}

variable "memory" {
    description = "The amount of RAM"
    type = number
    default = 2048
}

variable "disk_size" {
    description = "The disk size to give each VM"
    type = string
    default = "10G"
}

variable "storage" {
    description = "The storage on the host to use"
    type = string
}

variable "ip_start" {
    description = "The starting point for IP addresses (192.168.1.10 + count.index)"
    type = string
}

variable "network_gateway" {
    description = "The network gateway"
    type = string
}

variable "ssh_key" {
    description = "The SSH key to add"
    type = string
}