resource "helm_release" "palworld" {
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
      client_id     = var.client_id
      client_secret = var.client_secret
    })
  ]
}

data "http" "crd_yaml_file" {
  for_each = toset(local.crd_urls)
  url      = each.value
}

resource "random_uuid" "example" {
  for_each = toset(local.crd_urls)
  lifecycle {
    precondition {
      condition     = contains([200, 201, 204], data.http.crd_yaml_file[each.value].status_code)
      error_message = "Status code invalid '${data.http.crd_yaml_file[each.value].status_code}'- faield to download crd for version ${var.helm_chart_version}"
    }
  }
}

resource "kubectl_manifest" "crd_install" {
  for_each   = toset(local.crd_urls)
  yaml_body  = data.http.crd_yaml_file[each.value].response_body
  depends_on = [random_uuid.example]
  apply_only = true
}