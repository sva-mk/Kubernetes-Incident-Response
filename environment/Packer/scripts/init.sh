#! /bin/bash

export DEBIAN_FRONTEND=noninteractive
cloud-init status --wait
apt-get update -qq
apt-get upgrade -y -qq

sed -i -r "s/127.0.0.53/$DNS_SERVER/g" /etc/resolv.conf