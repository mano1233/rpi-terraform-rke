locals {
  spit_helm_chart_version = substr(var.helm_chart_version, 0, 4)
  helm_crd_path           = "https://raw.githubusercontent.com/strimzi/strimzi-kafka-operator/${var.helm_chart_version}/helm-charts/helm3/strimzi-kafka-operator/crds/"
  crds_names = [
    "040-Crd-kafka.yaml",
    "041-Crd-kafkaconnect.yaml",
    "042-Crd-strimzipodset.yaml",
    "043-Crd-kafkatopic.yaml",
    "045-Crd-kafkamirrormaker.yaml",
    "046-Crd-kafkabridge.yaml",
    "047-Crd-kafkaconnector.yaml",
    "048-Crd-kafkamirrormaker2.yaml",
    "049-Crd-kafkarebalance.yaml",
    "04A-Crd-kafkanodepool.yaml"
  ]
  crds_urls = [for yaml_name in local.crds_names : "${local.helm_crd_path}${yaml_name}"]
}
