variable "HCP_CLIENT_ID" {
  type = string
}

variable "HCP_CLIENT_SECRET" {
  type = string
}


variable "tailscale_use_vault" {
  type        = bool
  default     = true
  description = "(Required) Use vault to store the client_id and client_secret."
}

variable "tailscale_vault_client_id_secret_name" {
  type        = string
  default     = "tailscale_client_id"
  description = "(Optional) The name of the secret in vault that contains the client_id."
}

variable "tailscale_vault_client_secret_secret_name" {
  type        = string
  default     = "tailscale_client_secret"
  description = "(Optional) The name of the secret in vault that contains the client_secret."
}

variable "tailscale_client_id" {
  type        = string
  default     = "chngeit"
  description = "(Optional) The name of the secret in vault that contains the client_id."
}

variable "tailscale_client_secret" {
  type        = string
  default     = "changeit"
  description = "(Optional) The name of the secret in vault that contains the client_secret."
}