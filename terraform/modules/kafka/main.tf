resource "kubectl_manifest" "kafka_nodepool" {
  yaml_body = templatefile("${path.module}/defaultnodepool.yaml.tfpl", {
    # General
    replicas     = var.brokers
    cluster_name = var.kafka_cluster_name

    # Pod Annotations
    pod_annotations = local.pod_annotations


    # Resources
    request_memory = var.resources.requested_memory
    limit_memory   = var.resources.limit_memory
    request_cpu    = var.resources.requested_cpu
    limit_cpu      = var.resources.limit_cpu

    # JVM
    jvm_xmx = var.jvm.xmx
    jvm_xms = var.jvm.xms

    # Connections
    hosted_zone_name = var.hosted_zone_name

    # Kafka Configuration
    kafka_config = local.kafka_config

    #Node Affinity
    node_affinity = var.affinity
    tolerations   = var.tolerations

    # Kafka Metrics Annotations
    jmx_metrics_config = file("${path.module}/jmx_metrics_config/metrics_config.yaml")

    #Storage
    storage_class        = local.storage.class
    storage_size         = local.storage.size
    storage_delete_claim = local.storage.delete_claim
    zones                = var.zones
  })
}
