resource "helm_release" "strimzi_kafka_operator" {
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
    templatefile("${path.module}/helm-values.tftpl", {
      replicas             = var.replicas
      watchAnyNamespace    = var.watch_any_namespace
      logLevel             = var.log_level
      defaultImageRegistry = var.docker_registry
      requested_memory     = var.resources.requested_memory
      requested_cpu        = var.resources.requested_cpu
      limit_memory         = var.resources.limit_memory
      limit_cpu            = var.resources.limit_cpu
      feature_gates        = var.feature_gates == "-" ? null : var.feature_gates
    })
  ]
}


# Helm release has a limitation: it doesn't manage the lifecycle of CRDs, 
# meaning it will only install the CRDs during the first installation of a chart. 
# Upgrades will not change the CRDS themselves.
# The following senction will download the crds from the version and apply them for the upgarde.
data "http" "crd_yaml_file" {
  for_each = toset(local.crds_urls)
  url      = each.value
}

resource "random_uuid" "example" {
  for_each = toset(local.crds_urls)
  lifecycle {
    precondition {
      condition     = contains([200, 201, 204], data.http.crd_yaml_file[each.value].status_code)
      error_message = "Status code invalid '${data.http.crd_yaml_file[each.value].status_code}'- failed to download strimzi operator helm version '${var.helm_chart_version}' CRDS."
    }
  }
}

resource "kubectl_manifest" "crd_install" {
  for_each   = toset(local.crds_urls)
  yaml_body  = data.http.crd_yaml_file[each.value].response_body
  depends_on = [random_uuid.example]
  apply_only = true
}
