terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.11.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.58"
    }
    pihole = {
      source  = "lukaspustina/pihole"
      version = "0.3.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc05"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
