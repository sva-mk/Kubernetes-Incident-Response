node_pools = [
  {
    name            = "openshift"
    size            = 3
    ip_list         = ["172.30.0.19", "172.30.0.26", "172.30.0.27"]
    ipv4_gateway    = "172.30.0.254"
    ipv4_netmask    = 24
    is_master       = true
    dns_server_list = ["8.8.8.8"]
  },

  {
    name            = "openshift-worker"
    size            = 3
    ip_list         = ["172.30.0.28", "172.30.0.29", "172.30.0.30"]
    ipv4_gateway    = "172.30.0.254"
    ipv4_netmask    = 24
    is_master       = false
    dns_server_list = ["8.8.8.8"]
  },
]

# Kubernetes config
kube_network_cni               = "calico"
kube_version                   = "v1.28.4"
kube_container_runtime_version = "1.28"
kube_container_runtime         = "crio"
