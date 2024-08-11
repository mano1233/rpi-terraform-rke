################################################################################
# Required variables
################################################################################
variable "kafka_cluster_name" {
  type        = string
  description = "(Required) The name that will be given to the kafka cluster."
}

variable "affinity" {
  type = list(object({
    key      = optional(string)
    operator = optional(string, "In")
    values   = optional(list(string))
  }))
  description = "(Required) Affinity labels that are used on dedicated Kafka nodes."
}

variable "tolerations" {
  type = list(object({
    key      = optional(string)
    operator = optional(string, "Equal")
    value    = optional(string)
    effect   = optional(string, "NoSchedule")
  }))
  description = "(Required) tolerations that are used on dedicated Kafka nodes."
}

variable "hosted_zone_name" {
  type        = string
  description = "(Required) AWS route53 hosted zone name where the brokers records will get created to"
}

variable "storage" {
  type        = map(string)
  description = "(Required) Kafka Brokers persistence storage configuration"
}

variable "zones" {
  type        = list(string)
  description = "(Required) Availability zones to distribute evenly between the brokers."
}

variable "resources" {
  type        = map(string)
  description = "(Required) Resource requests/limit (CPU and Memory) to specify the maximum resources that can be consumed."
}

variable "configmap_name" {
  description = "(Required) ConfigMap deployment name that holds Kafka Metrics"
  type        = string
}

variable "configmap_key" {
  description = "(Required) ConfigMap deployment key that holds Kafka Metrics"
  type        = string
}

variable "jvm" {
  type        = map(string)
  description = <<EOT
  (Required) Confiuration of JVM options for maximum and minimum memory allocation:
  -Xms = Minimum initial allocation heap size when the JVM starts.
  -Xmx = Maximum heap size.
  EOT
}

################################################################################
# Optional variables
################################################################################

variable "kafka_version" {
  type        = string
  description = "(Optional) The Kafka version."
  default     = "3.6.0"
}

variable "brokers" {
  type        = number
  description = "(Optional) Number of Kafka brokers to create."
  default     = 3
  validation {
    condition     = var.brokers % 3 == 0
    error_message = "The number of brokers must be divisible by 3."
  }
}

variable "root_log_level" {
  type        = string
  description = <<EOF
  (Optional) log level value must be one of:
  ```
  [INFO, ERROR, WARN, TRACE, DEBUG, FATAL, OFF]
  ```
  EOF
  default     = "INFO"
}

variable "kafka_config" {
  type        = map(string)
  description = "(Optional) Additional Kafka base configuration."
  default = {
    "auto.create.topics.enable"                           = "false"
    "auto.leader.rebalance.enable"                        = "false"
    "delete.topic.enable"                                 = "true"
    "controlled.shutdown.enable"                          = "true"
    "num.recovery.threads.per.data.dir"                   = "2"
    "num.replica.fetchers"                                = "4"
    "socket.send.buffer.bytes"                            = "1048576"
    "socket.receive.buffer.bytes"                         = "1048576"
    "socket.request.max.bytes"                            = "104857600"
    "offsets.topic.replication.factor"                    = "3"
    "transaction.state.log.replication.factor"            = "3"
    "transaction.state.log.min.isr"                       = "1"
    "default.replication.factor"                          = "3"
    "min.insync.replicas"                                 = "1"
    "replica.selector.class"                              = "org.apache.kafka.common.replica.RackAwareReplicaSelector"
    "log.flush.scheduler.interval.ms"                     = "2000"
    "client.quota.callback.class"                         = "io.strimzi.kafka.quotas.StaticQuotaCallback"
    "client.quota.callback.static.storage.check-interval" = "600"
    "group.initial.rebalance.delay.ms"                    = "6000"
    "log.retention.hours"                                 = "24"
    "num.network.threads"                                 = "4"
    "message.timestamp.type"                              = "LogAppendTime"
  }
}

variable "service_annotations" {
  type        = map(string)
  description = "(Optional) Attached annotations to the Kafka External Bootsrap Service"
  default = {
    "consul.hashicorp.com/service-sync" = "true"
  }
}

variable "pod_annotations" {
  type        = map(string)
  description = "(Optional) Attached annotations to the Kafka pods"
  default = {
    "karpenter.sh/do-not-disrupt" = "true"
  }
}

variable "ports" {
  type        = map(string)
  description = "(Optional) Ports to be used by the Kafka brokers internal and external network."
  default = {
    "internal_port" = 9092
    "external_port" = 9094
  }
}

variable "listener_tls" {
  type        = map(string)
  description = "(Optional) Wehter to activate tls on a specific listenter."
  default = {
    "internal_tls_enabled" = "true"
    "external_tls_enabled" = "true"
  }
}

variable "bootstrap_node_port" {
  type        = number
  description = "(Optional) The max port available to use starting range from 32100."
  default     = 32300
}

