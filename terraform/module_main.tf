module "tailscale" {
  source        = "./modules/tailscale"
  client_id     = var.tailscale_use_vault ? data.hcp_vault_secrets_app.mano_smart_home.secrets[var.tailscale_vault_client_id_secret_name] : var.tailscale_client_id
  client_secret = var.tailscale_use_vault ? data.hcp_vault_secrets_app.mano_smart_home.secrets[var.tailscale_vault_client_secret_secret_name] : var.tailscale_client_secret

  # Configurable Variables
  helm_chart_version = local.tailscale.helm_chart_version
  create_namespace   = local.tailscale.create_namespace
  timeout            = local.tailscale.timeout
  cleanup_on_fail    = local.tailscale.cleanup_on_fail
  wait               = local.tailscale.wait
  helm_release_name  = local.tailscale.helm_release_name
  helm_chart_name    = local.tailscale.helm_chart_name
  helm_repo_url      = local.tailscale.helm_repo_url
  namespace          = local.tailscale.namespace
  atomic             = local.tailscale.atomic


}

module "cert-manager" {
  source = "./modules/cert-manager"

  # Configurable Variables
  namespace             = local.cert-manager.namespace
  timeout               = local.cert-manager.timeout
  cleanup_on_fail       = local.cert-manager.cleanup_on_fail
  docker_image          = local.cert-manager.docker_image
  docker_image_injector = local.cert-manager.docker_image_injector
  helm_chart_version    = local.cert-manager.helm_chart_version
  helm_chart_name       = local.cert-manager.helm_chart_name
  helm_repo_url         = local.cert-manager.helm_repo_url
  docker_pull_policy    = local.cert-manager.docker_pull_policy
  docker_image_webhook  = local.cert-manager.docker_image_webhook
  docker_image_startup  = local.cert-manager.docker_image_startup
  helm_release_name     = local.cert-manager.helm_release_name
  create_namespace      = local.cert-manager.create_namespace
  docker_image_acme     = local.cert-manager.docker_image_acme
  atomic                = local.cert-manager.atomic
  wait                  = local.cert-manager.wait


}


module "nifikop" {
  source = "./modules/nifi-kop"
  #num_crd_created_cert_manager = module.cert-manager.num_crd_created
  cert_manager_namespace = module.cert-manager.namespace
  # Configurable Variables
  create_namespace   = local.nifi-kop.create_namespace
  timeout            = local.nifi-kop.timeout
  docker_pull_policy = local.nifi-kop.docker_pull_policy
  helm_chart_version = local.nifi-kop.helm_chart_version
  helm_chart_name    = local.nifi-kop.helm_chart_name
  helm_repo_url      = local.nifi-kop.helm_repo_url
  namespace          = local.nifi-kop.namespace
  docker_image       = local.nifi-kop.docker_image
  bootstrap_issuers  = local.nifi-kop.bootstrap_issuers
  helm_release_name  = local.nifi-kop.helm_release_name
  atomic             = local.nifi-kop.atomic
  wait               = local.nifi-kop.wait
  cleanup_on_fail    = local.nifi-kop.cleanup_on_fail


  depends_on = [module.cert-manager]



}

module "nifi-cluster" {
  source = "./modules/nifi-cluster"
  #num_crd_created_cert_manager = module.cert-manager.num_crd_created
  #cert_manager_namespace = module.cert-manager.namespace
  nifi_issuer_name = module.nifikop.nifi_issuer_name
  # Configurable Variables
  namespace          = local.nifi-cluster.namespace
  atomic             = local.nifi-cluster.atomic
  cleanup_on_fail    = local.nifi-cluster.cleanup_on_fail
  docker_image       = local.nifi-cluster.docker_image
  helm_chart_version = local.nifi-cluster.helm_chart_version
  wait               = local.nifi-cluster.wait
  cluster_name       = local.nifi-cluster.cluster_name
  helm_chart_name    = local.nifi-cluster.helm_chart_name
  helm_repo_url      = local.nifi-cluster.helm_repo_url
  dns_suffix         = local.nifi-cluster.dns_suffix
  helm_release_name  = local.nifi-cluster.helm_release_name
  create_namespace   = local.nifi-cluster.create_namespace
  timeout            = local.nifi-cluster.timeout
  docker_pull_policy = local.nifi-cluster.docker_pull_policy

}
