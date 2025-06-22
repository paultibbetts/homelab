variable "enable_debug" {
  type    = bool
  default = false
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure

  pm_log_enable = var.enable_debug
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = var.enable_debug
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }

}

