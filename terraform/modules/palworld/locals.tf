locals {
  crd_path = "https://raw.githubusercontent.com/tailscale/tailscale/v${var.helm_chart_version}/cmd/k8s-operator/deploy/crds/"
  crds_names = [
    "tailscale.com_connectors.yaml",
    "tailscale.com_dnsconfigs.yaml",
    "tailscale.com_proxyclasses.yaml"
  ]
  crd_urls = [for yaml_name in local.crds_names : "${local.crd_path}${yaml_name}"]

}