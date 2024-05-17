
locals {
  # username that terraform will use to ssh to the node(s)
  user = "bifrostoverseer"

  # the filename of the private key used to ssh to the node(s)
  private_key = "bifrostoverseer"

  # the list of nodes that will be bootstrapped
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