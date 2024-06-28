module "home_cluster" {
  source = "../../terraform"
  bootstrap = {
    nodes = {
      node1 = {
        hostname   = "asgard"
        ip_address = "10.0.0.85"
        roles      = ["controlplane", "worker", "etcd"]
      },
      node2 = {
        hostname   = "jotunheim"
        ip_address = "10.0.0.83"
        roles      = ["worker", "etcd"]
      },
      node3 = {
        hostname   = "nidavellir"
        ip_address = "10.0.0.84"
        roles      = ["worker", "etcd"]
      }
    }
    private_key = file("${path.module}/bifrostoverseer")
    ssh_user    = "bifrostoverseer"
  }
}