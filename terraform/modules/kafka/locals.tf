locals {
  storage = merge(
    tomap({
      size         = "6982Gi"
      class        = "nvme-ssd"
      delete_claim = "true"
    }),
    var.storage,
  )

  kafka_config = merge(
    tomap({
      "auto.create.topics.enable"                = "false"
      "auto.leader.rebalance.enable"             = "false"
      "delete.topic.enable"                      = "true"
      "controlled.shutdown.enable"               = "true"
      "num.recovery.threads.per.data.dir"        = "2"
      "num.replica.fetchers"                     = "4"
      "socket.send.buffer.bytes"                 = "1048576"
      "socket.receive.buffer.bytes"              = "1048576"
      "socket.request.max.bytes"                 = "104857600"
      "offsets.topic.replication.factor"         = "3"
      "transaction.state.log.replication.factor" = "3"
      "transaction.state.log.min.isr"            = "1"
      "default.replication.factor"               = "3"
      "min.insync.replicas"                      = "1"
      "inter.broker.protocol.version"            = "'${substr(var.kafka_version, 0, 3)}'"
      "log.message.format.version"               = "'${substr(var.kafka_version, 0, 3)}'"
      "replica.selector.class"                   = "org.apache.kafka.common.replica.RackAwareReplicaSelector"
      "log.flush.scheduler.interval.ms"          = "2000"
      #"client.quota.callback.class" = "io.strimzi.kafka.quotas.StaticQuotaCallback"
      #"client.quota.callback.static.storage.check-interval" = "600"
      "group.initial.rebalance.delay.ms" = "6000"
      "log.retention.hours"              = "24"
      "num.io.threads"                   = "${trim(var.resources.limit_cpu, "m") / 1000}"
      "num.network.threads"              = "4"
      #"listener.name.EXTERNAL-9094.num.network.threads" = "6"
      #"client.quota.callback.static.storage.soft" = "${tonumber(substr(local.storage.size, 0, 2)) * 1000000000 * 0.98}"
      #"client.quota.callback.static.storage.hard" = "${tonumber(substr(local.storage.size, 0, 2)) * 1000000000 * 0.95}"
    }),
    var.kafka_config,
    trim(var.resources.limit_cpu, "m") / 1000 >= 9 ? { "num.network.threads" = "8" } : {}
  )

  service_annotations = merge(
    tomap({
      "consul.hashicorp.com/service-sync" = "true"
      "consul.hashicorp.com/service-name" = "strimzi-kafka-${var.kafka_cluster_name}"
    }),
    var.service_annotations,
  )

  pod_annotations = merge(
    tomap({
      "karpenter.sh/do-not-disrupt" = "true"
    }), var.pod_annotations
  )

  ports = merge(
    tomap({
      "internal_port" = 9092
      "external_port" = 9094
    }),
    var.ports,
  )

  listener_tls = merge(
    tomap({
      "internal_tls_enabled" = "true"
      "external_tls_enabled" = "true"
    }),
    var.listener_tls,
  )

}
