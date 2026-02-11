# Ansible
# ansible_user: root

# Kubernetes
kubernetes_engine: ${kube_kubernetes_engine}
kube_version: ${kube_version}
token: ${kube_token}

# 1.8.x feature: --feature-gates SelfHosting=true
init_opts: "${kube_init_opts}"

# Any other additional opts you want to add..
kubeadm_opts: "${kube_kubeadm_opts}"
# For example:
# kubeadm_opts: '--apiserver-cert-extra-sans "k8s.domain.com,kubernetes.domain.com"'

service_cidr: ${kube_service_cidr}
pod_network_cidr: ${kube_pod_network_cidr}

# Network implementation('flannel', 'calico', 'canal', 'weave-net')
network_cni: ${kube_network_cni}

# Change this to an appropriate interface, preferably a private network.
# For example, on DigitalOcean, you would use eth1 as that is the default private network interface.
network_interface: ${kube_network_interface}

enable_dashboard: ${kube_enable_dashboard}

# A list of insecure registries you might need to define
# insecure_registries: []
insecure_registries: [%{ for registry in kube_insecure_registries ~}'${registry}',%{ endfor ~}]

systemd_dir: ${kube_systemd_dir}
system_env_dir: ${kube_system_env_dir}
network_dir: ${kube_network_dir}
kubeadmin_config: ${kube_kubeadmin_config}
kube_addon_dir: ${kube_addon_dir}

# Additional feature to install
additional_features:
%{ for key, value in kube_additional_features ~}
  ${key}: ${value}
%{ endfor ~}

# temporary directory used by additional features
tmp_dir: ${kube_tmp_dir}

# Container runtimes ('containerd', 'crio')
container_runtime: ${kube_container_runtime}
container_runtime_version: ${kube_container_runtime_version}
sandbox_image_version: ${kube_sandbox_image_version}
containerd_use_systemd: "${kube_containerd_use_systemd}"
crio_os_version: ${kube_crio_os_version}

# Cilium konfig
cilium_cli_version: ${cilium_cli_version}
