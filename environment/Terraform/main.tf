resource "vsphere_folder" "customer" {
  path          = "${var.vsphere_folder}/${terraform.workspace}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.worker_datacenter.id
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "local_file" "ssh_keys" {
  content         = tls_private_key.ssh_key.private_key_openssh
  filename        = "./.ssh/id_${terraform.workspace}"
  file_permission = "0700"
}

resource "local_file" "ssh_key_pub" {
  content         = tls_private_key.ssh_key.public_key_openssh
  filename        = "./.ssh/id_${terraform.workspace}.pub"
  file_permission = "0700"
}

resource "local_file" "ansible_variables" {
  depends_on = [vsphere_virtual_machine.worker_nodes, vsphere_virtual_machine.master_nodes]
  content = templatefile("${path.module}/templates/all.yml.tpl", {
    kube_version                   = var.kube_version
    kube_token                     = var.kube_token
    kube_init_opts                 = var.kube_init_opts
    kube_kubeadm_opts              = var.kube_kubeadm_opts
    kube_service_cidr              = var.kube_service_cidr
    kube_pod_network_cidr          = var.kube_pod_network_cidr
    kube_network_cni               = var.kube_network_cni
    kube_network_interface         = var.kube_network_interface
    kube_enable_dashboard          = var.kube_enable_dashboard
    kube_insecure_registries       = var.kube_insecure_registries
    kube_systemd_dir               = var.kube_systemd_dir
    kube_system_env_dir            = var.kube_system_env_dir
    kube_network_dir               = var.kube_network_dir
    kube_kubeadmin_config          = var.kube_kubeadmin_config
    kube_addon_dir                 = var.kube_addon_dir
    kube_additional_features       = var.kube_additional_features
    kube_tmp_dir                   = var.kube_tmp_dir
    kube_container_runtime         = var.kube_container_runtime
    kube_container_runtime_version = var.kube_container_runtime_version
    kube_sandbox_image_version     = var.kube_sandbox_image_version
    kube_containerd_use_systemd    = var.kube_containerd_use_systemd
    kube_crio_os_version           = var.kube_crio_os_version
    kube_kubernetes_engine         = var.kube_kubernetes_engine
    cilium_cli_version             = var.cilium_cli_version
  })
  filename = "${path.root}/../Ansible/.terraform/${terraform.workspace}/all.yml"

  provisioner "local-exec" {
    command = "sleep 50"
  }

}

resource "local_file" "ansible" {
  depends_on = [vsphere_virtual_machine.worker_nodes, vsphere_virtual_machine.master_nodes, local_file.ansible_variables]
  content = templatefile("${path.module}/templates/hosts.ini.tpl", {
    mapped_nodes     = local.mapped_nodes
    ssh_username     = var.ssh_username
    ssh_password     = var.ssh_password
    workspace        = terraform.workspace
    var_file         = local_file.ansible_variables.filename
    docker_user      = var.docker_user
    docker_password  = var.docker_password
    docker_mirror_ip = var.docker_mirror_ip
  })
  filename = "${path.root}/../Ansible/.terraform/${terraform.workspace}/host.ini"

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${path.root}/../Ansible/.terraform/${terraform.workspace}/host.ini'  --private-key ${path.root}/.ssh/id_${terraform.workspace} -e 'pub_key=${path.root}/.ssh/id_${terraform.workspace}.pub' ./../Ansible/install-${var.kube_kubernetes_engine}.yml"
  }
}