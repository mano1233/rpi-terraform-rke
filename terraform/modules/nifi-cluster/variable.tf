# Helm Variables

variable "helm_chart_version" {
  type        = string
  default     = "1.9.0"
  description = "(Optional) Version of the Helm chart."
}

variable "helm_release_name" {
  type        = string
  default     = "nifi-cluster"
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "helm_chart_name" {
  type        = string
  default     = "nifi-cluster"
  description = "(Optional) Helm chart NAme."
}

variable "helm_repo_url" {
  type        = string
  default     = "oci://ghcr.io/konpyutaika/helm-charts/"
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "namespace" {
  type        = string
  default     = "nifi"
  description = "(Optional) The namespace to install the release to into."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "(Optional) Whether to create the specified namespace."
}

variable "atomic" {
  type        = bool
  default     = true
  description = "(Optional) If set. installation process purges chart on fail."
}

variable "wait" {
  type        = bool
  default     = true
  description = "(Optional) Will wait until all resources are in ready stat before marking the release successful."
}

variable "timeout" {
  type        = number
  default     = 300
  description = "(Optional) Time in seconds to wait for the chart to be installed."
}

variable "cleanup_on_fail" {
  type        = bool
  default     = true
  description = "(Optional) Allow deletion of new resources created when upgrade fails"
}

# Docker Variables

variable "docker_image" {
  type        = string
  default     = "apache/nifi"
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "docker_pull_policy" {
  type        = string
  default     = "IfNotPresent"
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "cluster_name" {
  type        = string
  default     = "nifi-cluster"
  description = "(Optional) The name of the pods that will be created by the chart."
  
}

variable "nifi_issuer_name" {
  type        = string
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "dns_suffix" {
  type        = string
  default     = "local"
  description = "(Optional) The name of the pods that will be created by the chart."
  
}

# variable "num_crd_created_cert_manager" {
#   type        = number
#   description = "Number of CRD created by cert-manager"
# }



