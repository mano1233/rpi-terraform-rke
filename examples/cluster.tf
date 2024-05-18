module "home_cluster" {
  source = "../terraform"
  bootstrap = {
    nodes = {
      node1 = {
        hostname = "asgard"
        ip_addr  = "10.0.0.85"
        role     = ["controlplane", "worker", "etcd"]
      },
      node2 = {
        hostname = "jotunheim"
        ip_addr  = "10.0.0.83"
        role     = ["worker", "etcd"]
      },
      node3 = {
        hostname = "nidavellir"
        ip_addr  = "10.0.0.84"
        role     = ["worker", "etcd"]
      }
    }
  }
}