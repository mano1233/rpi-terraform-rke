// Credentials can be set explicitly or via the environment variables HCP_CLIENT_ID and HCP_CLIENT_SECRET
provider "hcp" {
  client_id     = var.HCP_CLIENT_ID
  client_secret = var.HCP_CLIENT_SECRET
  project_id    = "6859e49a-6339-4967-a09f-6f1698150909"
}

provider "helm" {
  kubernetes {
    host                   = data.hcp_vault_secrets_app.mano_smart_home.secrets.k8s_host
    client_certificate     = base64decode(data.hcp_vault_secrets_app.mano_smart_home.secrets.k8s_client_cert)
    client_key             = base64decode(data.hcp_vault_secrets_app.mano_smart_home.secrets.k8s_client_key)
    cluster_ca_certificate = base64decode(data.hcp_vault_secrets_app.mano_smart_home.secrets.k8s_ca_cert)
  }
}

provider "kubectl" {
  host                   = data.hcp_vault_secrets_app.mano_smart_home.secrets.k8s_host
  client_certificate     = base64decode(data.hcp_vault_secrets_app.mano_smart_home.secrets.k8s_client_cert)
  client_key             = base64decode(data.hcp_vault_secrets_app.mano_smart_home.secrets.k8s_client_key)
  cluster_ca_certificate = base64decode(data.hcp_vault_secrets_app.mano_smart_home.secrets.k8s_ca_cert)
}

data "hcp_vault_secrets_app" "mano_smart_home" {
  app_name = "k8s-smart-home-secrets"
}


# output "test" {
#   value = data.hcp_vault_secrets_app.mano_smart_home
# }
