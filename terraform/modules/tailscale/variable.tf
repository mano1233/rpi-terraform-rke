# Helm Variables

variable "helm_chart_version" {
  type        = string
  default     = "v1.66.3"
  description = "(Optional) Version of the Helm chart."
}

variable "helm_release_name" {
  type        = string
  default     = "tailscale"
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "helm_chart_name" {
  type        = string
  default     = "tailscale"
  description = "(Optional) Helm chart NAme."
}

variable "helm_repo_url" {
  type        = string
  default     = "tailscale"
  description = "(Optional) The name of the pods that will be created by the chart."
}

variable "namespace" {
  type        = string
  default     = "tailscale"
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

variable "client_id" {
  type        = string
  default     = "ChangeIt"
  description = "(Required) the Id from tailscale admin panel"
}

variable "client_secret" {
  type        = string
  default     = "ChangeIt"
  description = "(Required) the secret from tailscale admin panel"
}