output "nifi_issuer_name" {
    value = kubectl_manifest.nifi-issuer[0].name
}
