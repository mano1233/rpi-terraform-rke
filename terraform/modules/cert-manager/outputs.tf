output "num_crd_created" {
  value = length(kubectl_manifest.crd_install)
}