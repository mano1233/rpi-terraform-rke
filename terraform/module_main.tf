module "tailscale" {
  source        = "./modules/tailscale"
  client_id     = var.tailscale_use_vault ? data.hcp_vault_secrets_app.mano_smart_home.secrets[var.tailscale_vault_client_id_secret_name] : var.tailscale_client_id
  client_secret = var.tailscale_use_vault ? data.hcp_vault_secrets_app.mano_smart_home.secrets[var.tailscale_vault_client_secret_secret_name] : var.tailscale_client_secret

  # Configurable Variables
  create_namespace   = local.tailscale.create_namespace
  timeout            = local.tailscale.timeout
  cleanup_on_fail    = local.tailscale.cleanup_on_fail
  helm_chart_version = local.tailscale.helm_chart_version
  helm_release_name  = local.tailscale.helm_release_name
  helm_chart_name    = local.tailscale.helm_chart_name
  wait               = local.tailscale.wait
  helm_repo_url      = local.tailscale.helm_repo_url
  namespace          = local.tailscale.namespace
  atomic             = local.tailscale.atomic


}

module "cert-manager" {
  source = "./modules/cert-manager"

  # Configurable Variables
  helm_chart_version    = local.cert-manager.helm_chart_version
  atomic                = local.cert-manager.atomic
  timeout               = local.cert-manager.timeout
  cleanup_on_fail       = local.cert-manager.cleanup_on_fail
  namespace             = local.cert-manager.namespace
  create_namespace      = local.cert-manager.create_namespace
  helm_repo_url         = local.cert-manager.helm_repo_url
  wait                  = local.cert-manager.wait
  docker_pull_policy    = local.cert-manager.docker_pull_policy
  docker_image_injector = local.cert-manager.docker_image_injector
  docker_image_startup  = local.cert-manager.docker_image_startup
  helm_release_name     = local.cert-manager.helm_release_name
  helm_chart_name       = local.cert-manager.helm_chart_name
  docker_image_acme     = local.cert-manager.docker_image_acme
  docker_image          = local.cert-manager.docker_image
  docker_image_webhook  = local.cert-manager.docker_image_webhook


}


module "nifikop" {
  source = "./modules/nifikop"

  # Configurable Variables
  wait               = local.nifi-kop.wait
  timeout            = local.nifi-kop.timeout
  docker_pull_policy = local.nifi-kop.docker_pull_policy
  helm_chart_version = local.nifi-kop.helm_chart_version
  helm_release_name  = local.nifi-kop.helm_release_name
  atomic             = local.nifi-kop.atomic
  create_namespace   = local.nifi-kop.create_namespace
  cleanup_on_fail    = local.nifi-kop.cleanup_on_fail
  docker_image       = local.nifi-kop.docker_image
  helm_chart_name    = local.nifi-kop.helm_chart_name
  helm_repo_url      = local.nifi-kop.helm_repo_url
  namespace          = local.nifi-kop.namespace




}
