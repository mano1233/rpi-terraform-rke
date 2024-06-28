// Credentials can be set explicitly or via the environment variables HCP_CLIENT_ID and HCP_CLIENT_SECRET
provider "hcp" {}

# provider helm {
#   kubernetes {
#     host                   = data.hcp_vault_secrets_app.mano_smart_home.k8s_host
#     client_certificate     = data.hcp_vault_secrets_app.mano_smart_home.k8s_client_cert
#     client_key             = data.hcp_vault_secrets_app.mano_smart_home.k8s_client_key
#     cluster_ca_certificate = data.hcp_vault_secrets_app.mano_smart_home.k8s_ca_cert
#   }
# }

# provider kubectl {
#   host                   = data.hcp_vault_secrets_app.mano_smart_home.k8s_host
#   client_certificate     = data.hcp_vault_secrets_app.mano_smart_home.k8s_client_cert
#   client_key             = data.hcp_vault_secrets_app.mano_smart_home.k8s_client_key
#   cluster_ca_certificate = data.hcp_vault_secrets_app.mano_smart_home.k8s_ca_cert
# }

resource "hcp_vault_secrets_app" "example" {
  app_name    = "example-app-name"
  description = "My new app!"
}

data "hcp_vault_secrets_secret" "k8s_host" {
  app_name = "k8s-smart-home-secrets"
  secret_name = "k8s_host"
} 
