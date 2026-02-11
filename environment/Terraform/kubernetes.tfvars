node_pools = [
  {
    name            = "test-pool"
    size            = 3
    ip_list         = ["172.30.0.12", "172.30.0.13", "172.30.0.14"]
    ipv4_gateway    = "172.30.0.254"
    ipv4_netmask    = 24
    is_master       = true
    dns_server_list = ["8.8.8.8"]
  },

  {
    name            = "test-worker"
    size            = 3
    ip_list         = ["172.30.0.15", "172.30.0.33", "172.30.0.34"]
    ipv4_gateway    = "172.30.0.254"
    ipv4_netmask    = 24
    is_master       = false
    dns_server_list = ["8.8.8.8"]
  },
]

# Kubernetes config
kube_network_cni               = "weave-net"
kube_version                   = "v1.28.5"
kube_container_runtime_version = "1.6.24-1"
kube_container_runtime         = "containerd"
