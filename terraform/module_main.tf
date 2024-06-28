module "tailscale" {
  source        = "./modules/tailscale"
  client_id     = var.tailscale_use_vault ? data.hcp_vault_secrets_app.mano_smart_home.secrets[var.tailscale_vault_client_id_secret_name] : var.tailscale_client_id
  client_secret = var.tailscale_use_vault ? data.hcp_vault_secrets_app.mano_smart_home.secrets[var.tailscale_vault_client_secret_secret_name] : var.tailscale_client_secret

  # Configurable Variables
  namespace          = local.tailscale.namespace
  create_namespace   = local.tailscale.create_namespace
  atomic             = local.tailscale.atomic
  timeout            = local.tailscale.timeout
  helm_chart_version = local.tailscale.helm_chart_version
  helm_release_name  = local.tailscale.helm_release_name
  helm_chart_name    = local.tailscale.helm_chart_name
  helm_repo_url      = local.tailscale.helm_repo_url
  wait               = local.tailscale.wait
  cleanup_on_fail    = local.tailscale.cleanup_on_fail


}
