# output "num_crd_created" {
#   value = length(kubectl_manifest.crd_install)
# }

output "namespace" {
  value = helm_release.cert-manager.namespace
}