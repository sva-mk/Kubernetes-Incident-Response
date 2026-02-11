#cloud-config
users:
  - default
  - name: ${ssh_username}
    passwd: "${build_password_encrypted}"
    shell: /bin/bash
    lock-passwd: false
    ssh_pwauth: True
    chpasswd: { expire: False }
    groups: users, admin, sudo
    ssh_authorized_keys:
     - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/ZXeVMYFhfwMWqa8a8UxtLBBfmFrMg2lnxBl9wbCWs"


autoinstall:
  version: 1
  apt:
    geoip: true
    preserve_sources_list: false
    primary:
      - arches: [amd64, i386]
        uri: http://archive.ubuntu.com/ubuntu
      - arches: [default]
        uri: http://ports.ubuntu.com/ubuntu-ports
  early-commands:
    - sudo systemctl stop ssh
  locale: en_US
  keyboard:
    layout: ${vm_guest_os_keyboard}
  storage:
    grub:
      reorder_uefi: False
    swap:
      size: 0
    config:
    - {ptable: gpt, path: /dev/sda, preserve: false, name: '', grub_device: false,
      type: disk, id: disk-sda}
    - {device: disk-sda, size: 536870912, wipe: superblock, flag: boot, number: 1,
      preserve: false, grub_device: true, type: partition, id: partition-sda1}
    - {fstype: fat32, volume: partition-sda1, preserve: false, type: format, id: format-2}
    - {device: disk-sda, size: 1073741824, wipe: superblock, flag: linux, number: 2,
      preserve: false, grub_device: false, type: partition, id: partition-sda2}
    - {fstype: ext4, volume: partition-sda2, preserve: false, type: format, id: format-0}
    - {device: disk-sda, size: -1, flag: linux, number: 3, preserve: false,
      grub_device: false, type: partition, id: partition-sda3}
    - name: vg-0
      devices: [partition-sda3]
      preserve: false
      type: lvm_volgroup
      id: lvm-volgroup-vg-0
    - {name: lv-root, volgroup: lvm-volgroup-vg-0, size: 100%, preserve: false,
      type: lvm_partition, id: lvm-partition-lv-root}
    - {fstype: ext4, volume: lvm-partition-lv-root, preserve: false, type: format,
      id: format-1}
    - {device: format-1, path: /, type: mount, id: mount-2}
    - {device: format-0, path: /boot, type: mount, id: mount-1}
    - {device: format-2, path: /boot/efi, type: mount, id: mount-3}
  identity:
    hostname: ${vm_hostname}
    username: ${ssh_username}
    password: ${build_password_encrypted}
  ssh:
    install-server: true
    allow-pw: true
  packages:
    - openssh-server
    - open-vm-tools
    - cloud-init
  user-data:
    disable_root: false
    timezone: ${vm_guest_os_timezone}
  
      

