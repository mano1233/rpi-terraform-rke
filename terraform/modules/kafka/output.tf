output "template" {
  value = templatefile("${path.module}/template.yaml.tftpl", {
    # General
    replicas       = var.brokers
    root_log_level = var.root_log_level
    version        = var.kafka_version
    cluster_name   = var.kafka_cluster_name

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

    #Service Annotations
    service_annotations = local.service_annotations

    #Storage
    storage_class        = local.storage.class
    storage_size         = local.storage.size
    storage_delete_claim = local.storage.delete_claim
    zones                = var.zones

    # ConfigMap
    configmap_name = var.configmap_name
    configmap_key  = var.configmap_key

    # Kafka Ports
    internal_port = local.ports.internal_port
    external_port = local.ports.external_port

    # TLS
    internal_tls_enabled = local.listener_tls.internal_tls_enabled
    external_tls_enabled = local.listener_tls.external_tls_enabled

    ## Kafka Metrics Annotations
    jmx_metrics_config = file("${path.module}/jmx_metrics_config/metrics_config.yaml")

    bootstrap_node_port = var.bootstrap_node_port
  })
}

output "ports" {
  value = local.ports
}

output "number_of_brokers" {
  value = var.brokers
}
