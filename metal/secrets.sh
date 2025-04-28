export TF_VAR_proxmox_api_url=$(pass pm_api_url)
export TF_VAR_proxmox_tls_insecure=true
export TF_VAR_proxmox_api_token_id=$(pass pm_api_token_id)
export TF_VAR_proxmox_api_token_secret=$(pass pm_api_token_secret)

export AWS_ENDPOINT_URL_S3=http://192.168.1.4:9000/
export AWS_ACCESS_KEY_ID=$(pass minio_access_key)
export AWS_SECRET_ACCESS_KEY=$(pass minio_secret_key)
