node_pools = [
  {
    name            = "master-pool"
    size            = 1
    ip_list         = ["172.30.0.16"]
    ipv4_gateway    = "172.30.0.254"
    ipv4_netmask    = 24
    is_master       = true
    dns_server_list = ["8.8.8.8"]
  },

  {
    name            = "worker-pool"
    size            = 3
    ip_list         = ["172.30.0.17", "172.30.0.18", "172.30.0.35"]
    ipv4_gateway    = "172.30.0.254"
    ipv4_netmask    = 24
    is_master       = false
    dns_server_list = ["8.8.8.8"]
  }
]

# Kubernetes config
kube_network_cni       = "flannel"
kube_version           = "v1.28.5"
kube_container_runtime = "containerd"
kube_kubernetes_engine = "k3s"
kube_kubeadmin_config  = "/etc/rancher/k3s/k3s.yaml"
