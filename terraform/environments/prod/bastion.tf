terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.3"
    }
  }
}


# Proxmox api connection details
variable "pm_api_url" {
  type = string
}

variable "pm_api_token_id" {
  type = string
}

variable "pm_api_token_secret" {
  type = string
}

variable "pm_tls_insecure" {
  type = bool
}

variable "pm_host" {
  type = string
  default = "hodor"
}



provider "proxmox" {

  pm_api_url = var.pm_api_url

  pm_api_token_id = var.pm_api_token_id

  pm_api_token_secret = var.pm_api_token_secret

  pm_tls_insecure = var.pm_tls_insecure
}

resource "proxmox_vm_qemu" "bastion" {
    vmid = 100
    name  = "bastion"
    target_node  = var.pm_host

    clone = "bastion-template"

    memory   = 2048
    cores    = 4
    sockets  = 1
    cpu      = "host"
    os_type  = "cloud-init"
    agent = 1

    disk {
        type     = "scsi"
        storage  = "local-lvm"
        size     = "30G"
        format   = "raw"
    }

    network {
        model   = "virtio"
        bridge  = "vmbr0"
        firewall = false
        macaddr = "52:54:00:00:01:00"
    }
    ipconfig0 = "ip=10.0.0.100/24,gw=10.0.0.1"

    network {
        model   = "virtio"
        bridge  = "vmbr1"
        firewall = false
        tag = 100
        macaddr = "52:54:01:00:01:00"
    }
    ipconfig1 = "ip=10.100.0.100/24"
}
