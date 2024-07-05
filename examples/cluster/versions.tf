terraform {

  cloud {
    organization = "smart-home-mano"

    workspaces {
      name = "smart-home-k8s"
    }
  }
}
