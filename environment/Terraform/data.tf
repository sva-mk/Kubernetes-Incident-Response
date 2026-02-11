locals {
  listed_nodes = flatten([
    for pool in var.node_pools :
    [
      for i in range(pool.size) :
      merge({
        name                    = pool.name
        is_master               = pool.is_master
        taints                  = pool.taints
        cores                   = pool.cores
        sockets                 = pool.sockets
        memory                  = pool.memory
        firmware                = pool.firmware
        efi_secure_boot_enabled = pool.efi_secure_boot_enabled
        ipv4_gateway            = pool.ipv4_gateway
        ipv4_netmask            = pool.ipv4_netmask
        ssh_username            = pool.ssh_username
        ssh_password            = pool.ssh_password
        #user           = pool.user

        vsphere_folder          = pool.vsphere_folder
        vsphere_network         = pool.vsphere_network
        vsphere_compute_cluster = pool.vsphere_compute_cluster
        vsphere_datastore       = pool.vsphere_datastore
        vsphere_template        = pool.vsphere_template
        dns_server_list         = pool.dns_server_list

        }, {
        i  = i
        ip = pool.ip_list[i]
      })
    ]
  ])

  mapped_nodes = {
    for node in local.listed_nodes : "${terraform.workspace}-${node.is_master ? "master" : "worker"}-${node.name}-${node.i}" => node
  }

}


data "vsphere_datacenter" "worker_datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_network" "network" {
  for_each      = local.mapped_nodes
  name          = coalesce(local.mapped_nodes[each.key].vsphere_network, var.vsphere_network)
  datacenter_id = data.vsphere_datacenter.worker_datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  for_each      = local.mapped_nodes
  name          = coalesce(local.mapped_nodes[each.key].vsphere_compute_cluster, var.vsphere_cluster)
  datacenter_id = data.vsphere_datacenter.worker_datacenter.id
}

data "vsphere_resource_pool" "pool" {
  for_each      = local.mapped_nodes
  name          = format("%s%s", data.vsphere_compute_cluster.cluster[each.key].name, "/Resources")
  datacenter_id = data.vsphere_datacenter.worker_datacenter.id
}

data "vsphere_datastore" "datastore" {
  for_each      = local.mapped_nodes
  name          = coalesce(local.mapped_nodes[each.key].vsphere_datastore, var.vsphere_datastore)
  datacenter_id = data.vsphere_datacenter.worker_datacenter.id
}

data "vsphere_virtual_machine" "template" {
  for_each      = local.mapped_nodes
  name          = coalesce(local.mapped_nodes[each.key].vsphere_template, var.vsphere_template)
  datacenter_id = data.vsphere_datacenter.worker_datacenter.id
}


