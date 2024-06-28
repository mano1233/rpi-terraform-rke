provider "helm" {
  kubernetes {
    host                   = module.bootstrap.rke_cluster.api_server_url
    client_certificate     = module.bootstrap.rke_cluster.client_cert
    client_key             = module.bootstrap.rke_cluster.client_key
    cluster_ca_certificate = module.bootstrap.rke_cluster.ca_crt
  }
}

provider "kubectl" {
  host                   = module.bootstrap.rke_cluster.api_server_url
  client_certificate     = module.bootstrap.rke_cluster.client_cert
  client_key             = module.bootstrap.rke_cluster.client_key
  cluster_ca_certificate = module.bootstrap.rke_cluster.ca_crt
}

