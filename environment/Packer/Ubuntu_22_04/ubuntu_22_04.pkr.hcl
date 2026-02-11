packer {
  required_version = ">= 1.9.1"
  required_plugins {
    git = {
      version = " >= 0.4.2"
      source  = "github.com/ethanmdavidson/git"
    }
    vsphere = {
      version = " >= v1.2.0"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}


data "git-repository" "cwd" {}
locals {
  build_by          = "${var.build_note} - Built by: HashiCorp Packer ${packer.version}"
  build_date        = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version     = data.git-repository.cwd.head
  build_description = "${local.build_by}\nVersion: ${local.build_version}\nBuilt on: ${local.build_date}"
  data_source_content = {
    "/meta-data" = file("${abspath(path.root)}/http/meta-data")
    "/user-data" = templatefile("${abspath(path.root)}/http/user-data.pkrtpl.hcl", {
      ssh_username             = var.ssh_username
      build_password_encrypted = var.build_password_encrypted
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
      vm_hostname              = var.vm_hostname
    })
  }
}


source "vsphere-iso" "ubuntu_22_04" {
  vcenter_server = var.vcenter_server
  username       = var.vcenter_user
  password       = var.vcenter_password
  datacenter     = var.vcenter_datacenter
  cluster        = var.vcenter_cluster
  host           = var.esx_host
  datastore      = var.vcenter_datastore
  folder         = var.vcenter_folder

  CPUs = var.vm_cpu_cores
  RAM  = var.vm_mem_size
  boot_command = [
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "c<wait5>",
    "set gfxpayload=keep<enter><wait5>",
    "linux /casper/vmlinuz <wait5>",
    "ip=${var.vm_ip}::${var.vm_gateway}:${var.vm_netmask}::eth0::${var.vm_dns} <wait5>",
    "autoinstall quiet fsck.mode=skip <wait5>",
    "net.ifnames=0 biosdevname=0 systemd.unified_cgroup_hierarchy=0 <wait5>",
    "ds=\"nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/\" <wait5>",
    "---<enter><wait5>",
    "initrd /casper/initrd<enter><wait5>",
    "boot<enter>"
  ]

  boot_wait = var.vm_boot_wait

  communicator         = "ssh"
  cpu_cores            = var.vm_cpu_cores
  disk_controller_type = ["pvscsi"]

  firmware      = "efi"
  guest_os_type = var.vm_guest_os_type

  insecure_connection = true
  iso_paths           = var.iso_paths
  network_adapters {
    network      = "DMZ0_VLAN_300"
    network_card = "vmxnet3"
  }
  notes                     = local.build_description
  remove_cdrom              = true
  ip_wait_address           = "172.30.0.0/24"
  shutdown_command          = "echo '${var.build_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout          = "60m"
  ssh_clear_authorized_keys = true
  ssh_password              = var.ssh_password
  ssh_timeout               = "1h"
  ssh_username              = var.ssh_username
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = true
  }
  vm_name             = var.vm_name
  convert_to_template = true
  http_content        = local.data_source_content
}


build {
  sources = ["source.vsphere-iso.ubuntu_22_04"]

  provisioner "shell" {
    execute_command = "echo ${var.ssh_password} | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "../scripts/init.sh"
    environment_vars = [
      "DNS_SERVER=${var.vm_dns}"
    ]
  }

  provisioner "shell" {
    execute_command = "echo ${var.ssh_password} | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "../scripts/cleanup.sh"
  }
  provisioner "file" {
    source      = "files/sshd_config"
    destination = "/tmp/sshd_config"
  }

  provisioner "shell" {
    inline = ["echo ${var.ssh_password} | sudo -S cp /tmp/sshd_config /etc/ssh/sshd_config",
    "echo ${var.ssh_password} | sudo -S chmod 644 /etc/ssh/sshd_config"]
  }


}
