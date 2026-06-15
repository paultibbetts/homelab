module "cloudflare" {
	source = "./modules/cloudflare"

	cloudflare_email = var.cloudflare_email
	cloudflare_api_token = var.cloudflare_api_token
}
