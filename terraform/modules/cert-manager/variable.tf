# Helm Variables

variable "helm_chart_version" {
  type        = string
  default     = "1.15.1"
  description = "(Optional) Version of the Helm chart."
}

variable "helm_release_name" {
  type        = string
  default     = "cert-manager"
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "helm_chart_name" {
  type        = string
  default     = "cert-manager"
  description = "(Optional) Helm chart NAme."
}

variable "helm_repo_url" {
  type        = string
  default     = "https://charts.jetstack.io"
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "namespace" {
  type        = string
  default     = "kube-system"
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
  default     = "quay.io/jetstack/cert-manager-controller"
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "docker_pull_policy" {
  type        = string
  default     = "IfNotPresent"
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "docker_image_webhook" {
  type        = string
  default     = "quay.io/jetstack/cert-manager-webhook"
  description = "(Optional) The image name of the webhook deployment."
}

variable "docker_image_injector" {
  type        = string
  default     = "quay.io/jetstack/cert-manager-cainjector"
  description = "(Optional) The image name of the injector deployment."
}

variable "docker_image_acme" {
  type        = string
  default     = "quay.io/jetstack/cert-manager-acmesolver"
  description = "(Optional) The image name of the acmesolver deployment."
}

variable "docker_image_startup" {
  type        = string
  default     = "quay.io/jetstack/cert-manager-startupapicheck"
  description = "(Optional) The image name of the startup deployment."

}

