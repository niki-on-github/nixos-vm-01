terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    sops = {
      source = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
