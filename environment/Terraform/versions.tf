
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.4.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.0.4"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
  required_version = ">= 1.5.0"
}