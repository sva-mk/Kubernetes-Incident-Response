node_pools = [
  {
    name             = "default-pool"
    size             = 3
    ip_list          = ["172.30.0.52", "172.30.0.53", "172.30.0.54"]
    ipv4_gateway     = "172.30.0.254"
    ipv4_netmask     = 24
    vsphere_template = "ubuntu-22.04"
    is_master        = true
  },
  {
    name         = "second-pool"
    size         = 3
    is_master    = false
    ip_list      = ["172.30.0.176", "172.30.0.181", "172.30.0.55"]
    ipv4_gateway = "172.30.0.254"
    ipv4_netmask = 24
  }
]


# Kubernetes config
kube_network_cni       = "cilium"
kube_version           = "v1.28.5"
kube_container_runtime = "containerd"
kube_kubernetes_engine = "rke2"
kube_kubeadmin_config  = "/etc/rancher/rke2/rke2.yaml"
cilium_cli_version     = "0.15.14"