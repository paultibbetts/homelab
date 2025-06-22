terraform {
	required_providers {
		cloudflare = {
			source = "cloudflare/cloudflare"
			version = "~> 5.6.0"
		}

		kubernetes = {
			source = "hashicorp/kubernetes"
			version = "~> 2.37.1"
		}

	}
}

provider "cloudflare" {
	email = var.cloudflare_email
	api_token = var.cloudflare_api_token
}

provider "kubernetes" {
	config_path = "~/.kube/config"
}
