resource "helm_release" "nifi-cluster" {
  name             = var.helm_release_name
  chart            = var.helm_chart_name
  repository       = var.helm_repo_url
  version          = var.helm_chart_version
  namespace        = var.namespace
  create_namespace = var.create_namespace
  atomic           = var.atomic
  wait             = var.wait
  timeout          = var.timeout
  cleanup_on_fail  = var.cleanup_on_fail

  values = [
    templatefile("${path.module}/helm-values.tfpl", {
      docker_image       = var.docker_image
      docker_pull_policy = var.docker_pull_policy
      cluster_name = var.cluster_name
      dns_suffix = var.dns_suffix
      nifi_issuer_name = var.nifi_issuer_name
    })
  ]
}