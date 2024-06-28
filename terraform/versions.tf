terraform {

  cloud {
    organization = "smart-home-mano"

    workspaces {
      name = "smart-home-k8s"
    }
  }
  required_version = ">= 0.13"
  required_providers {
    null = {
      source = "hashicorp/null"
    }
    time = {
      source = "hashicorp/time"
    }
    rke = {
      source = "rancher/rke"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.91.0"
    }
  }
}
