terraform {
  required_providers {
	cloudflare = {
		source = "cloudflare/cloudflare"
		version = "~> 5.11.0"
	}
	kubernetes = {
		source = "hashicorp/kubernetes"
		version = "~> 3.0.0"
	}
  }
  backend "s3" {
    bucket                      = "tfstate"
    key                         = "homelab-external.tfstate"
    region                      = "main" # region validation will be skipped
    skip_credentials_validation = true   # Skip AWS related checks and validations
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true # Enable path-style S3 URLs (https://<HOST>/<BUCKET> https://developer.hashicorp.com/terraform/language/settings/backends/s3#use_path_style
  }
}

