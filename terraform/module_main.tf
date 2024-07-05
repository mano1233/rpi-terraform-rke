module "tailscale" {
  source        = "./modules/tailscale"
  client_id     = var.tailscale_use_vault ? data.hcp_vault_secrets_app.mano_smart_home.secrets[var.tailscale_vault_client_id_secret_name] : var.tailscale_client_id
  client_secret = var.tailscale_use_vault ? data.hcp_vault_secrets_app.mano_smart_home.secrets[var.tailscale_vault_client_secret_secret_name] : var.tailscale_client_secret

  # Configurable Variables
  wait               = local.tailscale.wait
  timeout            = local.tailscale.timeout
  cleanup_on_fail    = local.tailscale.cleanup_on_fail
  helm_release_name  = local.tailscale.helm_release_name
  helm_chart_name    = local.tailscale.helm_chart_name
  helm_repo_url      = local.tailscale.helm_repo_url
  create_namespace   = local.tailscale.create_namespace
  helm_chart_version = local.tailscale.helm_chart_version
  namespace          = local.tailscale.namespace
  atomic             = local.tailscale.atomic


}

module "cert-manager" {
  source = "./modules/cert-manager"

  # Configurable Variables
  helm_release_name     = local.cert-manager.helm_release_name
  namespace             = local.cert-manager.namespace
  cleanup_on_fail       = local.cert-manager.cleanup_on_fail
  docker_pull_policy    = local.cert-manager.docker_pull_policy
  docker_image_startup  = local.cert-manager.docker_image_startup
  helm_chart_version    = local.cert-manager.helm_chart_version
  helm_repo_url         = local.cert-manager.helm_repo_url
  wait                  = local.cert-manager.wait
  create_namespace      = local.cert-manager.create_namespace
  atomic                = local.cert-manager.atomic
  docker_image_acme     = local.cert-manager.docker_image_acme
  helm_chart_name       = local.cert-manager.helm_chart_name
  timeout               = local.cert-manager.timeout
  docker_image          = local.cert-manager.docker_image
  docker_image_webhook  = local.cert-manager.docker_image_webhook
  docker_image_injector = local.cert-manager.docker_image_injector


}


module "nifikop" {
  source = "./modules/nifi-kop"
  #num_crd_created_cert_manager = module.cert-manager.num_crd_created
  # Configurable Variables
  timeout            = local.nifi-kop.timeout
  docker_image       = local.nifi-kop.docker_image
  docker_pull_policy = local.nifi-kop.docker_pull_policy
  namespace          = local.nifi-kop.namespace
  create_namespace   = local.nifi-kop.create_namespace
  atomic             = local.nifi-kop.atomic
  helm_repo_url      = local.nifi-kop.helm_repo_url
  wait               = local.nifi-kop.wait
  cleanup_on_fail    = local.nifi-kop.cleanup_on_fail
  bootstrap_issuers  = local.nifi-kop.bootstrap_issuers
  helm_chart_version = local.nifi-kop.helm_chart_version
  helm_release_name  = local.nifi-kop.helm_release_name
  helm_chart_name    = local.nifi-kop.helm_chart_name


  depends_on = [module.cert-manager]



}
