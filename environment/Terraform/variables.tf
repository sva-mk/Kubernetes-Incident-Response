
variable "vsphere_server" {
  type        = string
  description = "The Domain of the vsphere Server"
}

variable "vsphere_username" {
  type        = string
  sensitive   = true
  description = "The username used to log into the vsphere Server"
}

variable "vsphere_password" {
  type        = string
  sensitive   = true
  description = "The password used to log into the vsphere Server"
}

variable "vsphere_insecure" {
  type        = bool
  default     = false
  description = "Ignore SSL Certificate for vsphere"
}

# vSphere Settings

variable "vsphere_datacenter" {
  type        = string
  description = "The default datacenter used to create the nodes"

}

variable "vsphere_cluster" {
  type        = string
  description = "The default cluster used to create the nodes"

}

variable "vsphere_datastore" {
  type        = string
  description = "The default datastore used to create the nodes"

}


variable "vsphere_network" {
  type        = string
  description = "The default datacenter used to create the nodes"

}

variable "vsphere_template" {
  type        = string
  description = "The default template used to create the nodes"

}

variable "vsphere_folder" {
  type        = string
  description = "The default folder used to create the nodes"

}

variable "node_domain" {
  type        = string
  default     = ".soclab"
  description = "The domain ending used to create the nodes"

}

variable "dns_server_list" {
  type        = list(string)
  description = "The default list of dns servers used to create the nodes"

}

variable "cluster_name" {
  default     = "k8s"
  type        = string
  description = "Name of the cluster used for prefixing cluster components (ie nodes)."
}


variable "ssh_username" {
  default     = "user"
  type        = string
  description = "Name of the user used to connect to the node"
}

variable "ssh_password" {
  sensitive   = true
  type        = string
  description = "Password of the user used to connect to the node"
}


# Virtual Machine Settings
variable "node_pools" {
  description = "Node pool definitions for the nodes of the cluster."
  type = list(object({
    size                    = number,
    name                    = string,
    is_master               = bool
    taints                  = optional(list(string), []),
    cores                   = optional(number, 4),
    sockets                 = optional(number, 1),
    memory                  = optional(number, 4096),
    ip_list                 = list(string),
    dns_server_list         = optional(list(string), [])
    ipv4_netmask            = optional(number, 32)
    vsphere_folder          = optional(string, "")
    ipv4_gateway            = string
    firmware                = optional(string, "efi"),
    efi_secure_boot_enabled = optional(bool, false)
    vsphere_network         = optional(string, "")
    vsphere_compute_cluster = optional(string, "")
    vsphere_datastore       = optional(string, "")
    vsphere_template        = optional(string, "")
    ssh_username            = optional(string, "")
    ssh_password            = optional(string, "")
  }))
}




# Ansible Variables
variable "kube_version" {
  type        = string
  default     = "v1.28.3"
  description = "The kubernetes version that will be installed"
}

variable "kube_token" {
  type        = string
  default     = "b0f7b8.8d1767876297d86c"
  description = "The token used to init the cluster"
}

variable "kube_init_opts" {
  type        = string
  default     = ""
  description = "Additional options for cluster init"
}

variable "kube_kubeadm_opts" {
  type        = string
  default     = ""
  description = "Additional options for kubeadm"
}

variable "kube_service_cidr" {
  type        = string
  default     = "10.96.0.0/12"
  description = "The CIDR used for kubernetes services"
}


variable "kube_pod_network_cidr" {
  type        = string
  default     = "10.244.0.0/16"
  description = "The CIDR used for kubernetes pods"
}


variable "kube_network_cni" {
  type        = string
  default     = "flannel"
  description = "The CNI Addon that will be installed within kubernetes"
}


variable "kube_network_interface" {
  type        = string
  default     = "eth0"
  description = "The network interface used for kubernetes"
}

variable "kube_enable_dashboard" {
  type        = bool
  default     = true
  description = "If true, the default dashboard will be deployed"
}

variable "kube_insecure_registries" {
  type        = list(string)
  default     = ["gcr.io"]
  description = "A list of insecure registries you might need to define"
}

variable "kube_systemd_dir" {
  type        = string
  default     = "/lib/systemd/system"
  description = "The systemd directory on the nodes"
}

variable "kube_system_env_dir" {
  type        = string
  default     = "/etc/sysconfig"
  description = "The directory for the system config"
}

variable "kube_network_dir" {
  type        = string
  default     = "/etc/kubernetes/network"
  description = "The directory for the CNI"
}

variable "kube_kubeadmin_config" {
  type        = string
  default     = "/etc/kubernetes/admin.conf"
  description = "The location of the admin kubeconfig"
}

variable "kube_addon_dir" {
  type        = string
  default     = "/etc/kubernetes/addon"
  description = "The directory for kubernetes addons"
}

variable "kube_additional_features" {
  type = map(bool)
  default = {
    metallb     = false
    healthcheck = false
  }
  description = "A List of additional features, which could be enabled"
}

variable "kube_kubernetes_engine" {
  type        = string
  default     = "kubernetes"
  description = "The kubernetes engine to install ('kubernetes', 'k3s', 'rke2')"
}

variable "kube_tmp_dir" {
  type        = string
  default     = "/tmp/kubeadm-ansible-files"
  description = "The directory for temporary kubernetes files"
}

variable "kube_container_runtime" {
  type        = string
  default     = "containerd"
  description = "The container runtime used by kubernetes"
}

variable "kube_container_runtime_version" {
  type        = string
  default     = "undefined"
  description = "The cersion of the container runtime used by kubernetes"
}

variable "kube_sandbox_image_version" {
  type        = string
  default     = "registry.k8s.io/pause:3.9"
  description = "The sandbox image of the container runtime used by kubernetes"
}

variable "kube_containerd_use_systemd" {
  type        = string
  default     = "true"
  description = "The version of the container runtime used by kubernetes"
}

variable "kube_crio_os_version" {
  type        = string
  default     = "xUbuntu_22.04"
  description = "The version of the os used to install crio"
}

variable "docker_user" {
  type        = string
  sensitive   = true
  description = "The user used to login at docker.io"
}

variable "docker_password" {
  type        = string
  sensitive   = true
  description = "The password used to login at docker.io"
}

variable "docker_mirror_ip" {
  type        = string
  description = "The ip of the docker.io mirror"
}

variable "cilium_cli_version" {
  type        = string
  default     = "undefined"
  description = "The version of cilium to install"
}