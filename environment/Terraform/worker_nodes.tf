resource "vsphere_virtual_machine" "worker_nodes" {
  for_each                = { for key, value in local.mapped_nodes : key => value if !value.is_master }
  name                    = "${var.cluster_name}-${each.key}"
  folder                  = coalesce(each.value.vsphere_folder, resource.vsphere_folder.customer.path)
  num_cpus                = each.value.cores
  memory                  = each.value.memory
  firmware                = each.value.firmware
  efi_secure_boot_enabled = each.value.efi_secure_boot_enabled
  guest_id                = data.vsphere_virtual_machine.template[each.key].guest_id
  datastore_id            = data.vsphere_datastore.datastore[each.key].id
  resource_pool_id        = data.vsphere_resource_pool.pool[each.key].id
  network_interface {
    network_id = data.vsphere_network.network[each.key].id
  }
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template[each.key].disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.template[each.key].disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template[each.key].disks[0].thin_provisioned
    datastore_id     = data.vsphere_datastore.datastore[each.key].id
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template[each.key].id
    customize {
      network_interface {
        ipv4_address    = each.value.ip
        ipv4_netmask    = each.value.ipv4_netmask
        dns_server_list = coalesce(each.value.dns_server_list, var.dns_server_list)
      }
      linux_options {
        host_name = "${var.cluster_name}-${each.key}"
        domain    = "${var.cluster_name}-${each.key}${var.node_domain}"
      }
      ipv4_gateway = each.value.ipv4_gateway
    }
  }
  lifecycle {
    ignore_changes = [
      clone[0].template_uuid,
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "echo '${tls_private_key.ssh_key.public_key_openssh}' >> /home/user/.ssh/authorized_keys",
    ]
    connection {
      type     = "ssh"
      user     = coalesce(each.value.ssh_username, var.ssh_username)
      password = coalesce(each.value.ssh_password, nonsensitive(var.ssh_password))
      host     = each.value.ip
    }
  }

}