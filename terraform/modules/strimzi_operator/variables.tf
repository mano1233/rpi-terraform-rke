################################################################################
# Required variables
################################################################################
variable "resources" {
  type        = map(string)
  description = "(Required) Resource requests/limit (CPU and Memory) to specify the maximum resources that can be consumed."
}

################################################################################
# Optional variables
################################################################################
variable "replicas" {
  type        = number
  description = "(Optional) The number of replicas of strimzi operator to create."
  default     = 3
}

### HELM General values ###

variable "helm_release_name" {
  type        = string
  description = "(Optional) The name of the pods that will be created by the chart."
  default     = "strimzi-kafka-operator"
}

variable "helm_chart_name" {
  type        = string
  description = "(Optional) Helm chart name to be installed."
  default     = "strimzi-kafka-operator"
}

variable "helm_repo_url" {
  type        = string
  description = "(Optional) Repository URL where to locate the requested chart."
  default     = "oci://quay.io/strimzi-helm/"
}

variable "helm_chart_version" {
  type        = string
  description = "(Optional) Version of the Helm chart."
  default     = "0.41.0"
}

variable "namespace" {
  type        = string
  description = "(Optional) The namespace to install the release into."
  default     = "strimzi-operator"
}

variable "create_namespace" {
  type        = bool
  description = "(Optional) Whether to create k8s namespace with name defined by `namespace`"
  default     = true
}

variable "atomic" {
  type        = bool
  description = "(Optional) If set, installation process purges chart on fail."
  default     = true
}

variable "wait" {
  type        = bool
  description = "(Optional) Will wait until all resources are in a ready state before marking the release as successful."
  default     = true
}

variable "timeout" {
  type        = number
  description = "(Optional) Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks)."
  default     = 300
}

variable "cleanup_on_fail" {
  type        = bool
  description = "(Optional) Allow deletion of new resources created in this upgrade when upgrade fails."
  default     = true
}

### Chart Configurable variables ###

variable "watch_any_namespace" {
  type        = bool
  description = "(Optional) Enable Strimzi-Operator to watch all namespaces."
  default     = true
}

variable "log_level" {
  type        = string
  description = <<EOT
  (Optional) log level value can be one of:
  ```
  [INFO, ERROR, WARN, TRACE, DEBUG, FATAL, OFF]
  ```
  EOT
  default     = "info"
}

variable "feature_gates" {
  type        = string
  description = "(Optional) Feature gates to enable on the cluster."
  default     = "-"
}

### Docker Configuration ###
variable "docker_registry" {
  type        = string
  description = "(Optional) Docker image registry to pull the image from."
  default     = "packages.af-eng.io/docker"
}
