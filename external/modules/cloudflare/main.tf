data "cloudflare_api_token_permission_groups_list" "all" {

}

output "permission_names_scopes" {
  value = [
    for pg in data.cloudflare_api_token_permission_groups_list.all.result :
    {
      name   = pg.name
      scopes = pg.scopes
    }
  ]
}

locals {
	zone_read_id = [
		for pg in data.cloudflare_api_token_permission_groups_list.all.result : 
		pg.id if pg.name == "Zone Read" && contains(pg.scopes, "com.cloudflare.api.account.zone")
	][0]
  	dns_write_id = [
    		for pg in data.cloudflare_api_token_permission_groups_list.all.result :
    		pg.id if pg.name == "DNS Write" && contains(pg.scopes, "com.cloudflare.api.account.zone")
  	][0]
}


resource "cloudflare_api_token" "cert_manager" {
  name = "homelab_cert_manager"
  policies = [{
    effect = "allow"
    permission_groups = [
	{ id = local.zone_read_id },
	{ id = local.dns_write_id },
    ]
    resources = jsonencode({
      "com.cloudflare.api.account.zone.*" = "*"
    })
  }]
  status = "active"
}

resource "kubernetes_secret_v1" "cert_manager_token" {
	metadata {
		name = "cloudflare-api-token"
		namespace = "cert-manager"
	}

	data = {
		"api-token" = cloudflare_api_token.cert_manager.value
	}
}
