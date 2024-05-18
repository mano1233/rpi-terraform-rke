

module "bootstrap" {
  source = "./terraform/modules/bootstrap"

  # Dependency Injection - Required Fields 

  # Configurable Variables - Optinal Fields 
  nodes       = local.bootstrap.nodes
  private_key = local.bootstrap.private_key
  ssh_user    = local.bootstrap.ssh_user
}
module "tailscale" {
  source = "./terraform/modules/tailscale"

  # Dependency Injection - Required Fields 

  # Configurable Variables - Optinal Fields  
  atomic             = local.tailscale.atomic
  cleanup_on_fail    = local.tailscale.cleanup_on_fail
  client_id          = local.tailscale.client_id
  client_secret      = local.tailscale.client_secret
  create_namespace   = local.tailscale.create_namespace
  helm_chart_name    = local.tailscale.helm_chart_name
  helm_chart_version = local.tailscale.helm_chart_version
  helm_release_name  = local.tailscale.helm_release_name
  helm_repo_url      = local.tailscale.helm_repo_url
  namespace          = local.tailscale.namespace
  timeout            = local.tailscale.timeout
  wait               = local.tailscale.wait
}