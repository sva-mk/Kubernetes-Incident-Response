
variable "build_password_encrypted" {
  type        = string
  description = "The encrypted password to login the guest operating system."
  sensitive   = true
}

variable "vm_guest_os_language" {
  type        = string
  description = "The guest operating system lanugage."
  default     = "en_US"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = "The guest operating system keyboard input."
  default     = "de"
}

variable "vm_guest_os_timezone" {
  type        = string
  description = "The guest operating system timezone."
  default     = "Europe/Berlin"
}

variable "vm_hostname" {
  type        = string
  description = "The guest operating system hostname."
  default     = "ubuntu"
}

variable "vm_ip" {
  type        = string
  description = "The ip used to communicate with the vm."
  default     = ""
}

variable "vm_gateway" {
  type        = string
  description = "The gateway used to communicate with the vm."
  default     = ""
}

variable "vm_netmask" {
  type        = string
  description = "The netmask used to communicate with the vm."
  default     = "255.255.255.0"
}

variable "vm_dns" {
  type        = string
  description = "The dns used by the vm."
  default     = ""
}




variable "vcenter_folder" {
  type        = string
  description = "The folder to place to VM"
  default     = ""
}

variable "vcenter_server" {
  type        = string
  description = "The hostname of the vCenter server to use for building"
}

variable "vcenter_user" {
  type        = string
  description = "The username to use when connecting to the vCenter"
}

variable "vcenter_password" {
  type        = string
  sensitive   = true
  description = "The password for the vCenter user"
}

variable "vcenter_datacenter" {
  type        = string
  description = "The name of the datacenter within vCenter to build in"
  default     = null
}

variable "vcenter_cluster" {
  type        = string
  description = "The name of the cluster to build in"
  default     = null
}

variable "vcenter_resource_pool" {
  type        = string
  description = "The name of the resource pool to build in"
  default     = null
}

variable "vcenter_datastore" {
  type        = string
  description = "The name of the resource pool to build in"
  default     = null
}

variable "esx_host" {
  type        = string
  description = "The hostname of the ESX to build on"
  default     = null
}


variable "vm_boot_wait" {
  type        = string
  description = "The time to wait before boot. "
  default     = "5s"
}

variable "vm_guest_os_type" {
  type        = string
  description = "The guest operating system type, also know as guestid."
  default     = "ubuntu64Guest"
}





variable "vm_mem_size" {
  type        = number
  description = "The size for the virtual memory in MB."
  default     = 8192
}

variable "vm_cpu_cores" {
  type        = number
  description = "The number of virtual CPUs cores per socket."
  default     = 4
}

variable "vm_ssh_timeout" {
  type        = string
  description = "The duration the build pipeline waits for ssh to come back online."
  default     = "45m"
}

variable "ssh_username" {
  type        = string
  description = "The username to use to authenticate over SSH."
  default     = "root"
  sensitive   = true
}

variable "build_password" {
  type        = string
  description = "The plaintext password to use to build the template."
  default     = "Testen2023!"
  sensitive   = true
}

variable "build_note" {
  type        = string
  description = "A note added to the description of the vm"
  sensitive   = true
}

variable "ssh_password" {
  type        = string
  description = "The plaintext password to use to authenticate over SSH."
  default     = "Testen2023!"
  sensitive   = true
}

variable "vm_name" {
  type        = string
  description = "The template vm name"
  default     = ""
}

variable "vm_disk_size" {
  type        = number
  description = "The disc-size of the vm."
  default     = 50000
}

variable "iso_paths" {
  type        = list(string)
  default     = [""]
  description = "The location of the iso on the vsphere server used to install Ubuntu "
}
