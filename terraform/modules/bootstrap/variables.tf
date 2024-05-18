variable "nodes" {
  type = map(object({
    hostname   = string
    ip_address = string
    role       = list(string)
  }))
  default     = {}
  description = "(Required) Cluster nodes specification"
  validation {
    condition     = alltrue([for node in var.nodes : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", node.ip_address))])
    error_message = "The IP address must be a valid IPv4 address."
  }

  validation {
    condition     = alltrue(flatten([for node in nodes : [for role in node.roles : contains(["worker", "controlplane", "etcd"], role)]]))
    error_message = "Role must include atleast one of the following worker, controlplane, etcd"
  }

  validation {
    condition     = length([for server in values(var.server_map) : server if contains(server.role, "controlplane")]) > 0
    error_message = "There must be at least one server with the role 'controlplane'."
  }

  validation {
    condition     = length([for server in values(var.server_map) : server if contains(server.role, "etcd")]) > 3 || length(var.nodes) == 1
    error_message = "There must be at least three server with the role 'etcd'."
  }
}

variable "ssh_user" {
  type        = string
  description = "(Optional) SSH user to connect to nodes"
  default     = "root"
}

variable "private_key" {
  type        = string
  description = "The string value of the private key to use for the connection"
  default     = "null"
}

