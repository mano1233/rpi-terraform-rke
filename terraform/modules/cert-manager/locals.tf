locals {
  crd_path = "https://raw.githubusercontent.com/cert-manager/cert-manager/v${var.helm_chart_version}/deploy/crds/"
  crds_names = [
    "crd-certificaterequests.yaml",
    "crd-certificates.yaml",
    "crd-challenges.yaml",
    "crd-clusterissuers.yaml",
    "crd-issuers.yaml",
    "crd-orders.yaml"
  ]
  crd_urls = [for yaml_name in local.crds_names : "${local.crd_path}${yaml_name}"]

}