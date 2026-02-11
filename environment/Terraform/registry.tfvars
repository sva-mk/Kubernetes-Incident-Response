node_pools = [
  {
    name         = "registry"
    size         = 1
    ip_list      = ["172.30.0.111"]
    ipv4_gateway = "172.30.0.254"
    ipv4_netmask = 24
    is_master    = true
  },
]

kube_kubernetes_engine = "registry"