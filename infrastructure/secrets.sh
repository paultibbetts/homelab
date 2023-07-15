export TF_VAR_proxmox_api_url=$(pass pm_api_url)
export TF_VAR_proxmox_tls_insecure=true
export TF_VAR_proxmox_api_token_id=$(pass pm_api_token_id)
export TF_VAR_proxmox_api_token_secret=$(pass pm_api_token_secret)