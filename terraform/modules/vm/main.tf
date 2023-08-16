terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.3"
    }
  }
}

variable "ip0" {
  description = "IP address for the resource"
  type = string
}

variable "ip1" {
  description = "IP address for the resource"
  type = string
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

# Terraform Configuration for Proxmox VM
variable "vm_id" {
  description = "VM ID"
}

variable "vm_name" {
  description = "VM name"
}

variable "vm_template" {
  description = "VM template name or ID"
}

variable "vm_disk_size" {
  description = "VM disk size in GB"
  default     = 20
}

variable "vm_memory" {
  description = "VM memory in MB"
  default     = 1024
}

variable "vm_cores" {
  description = "Number of VM cores"
  default     = 1
}

provider "proxmox" {

  pm_api_url = var.pm_api_url

  pm_api_token_id = var.pm_api_token_id

  pm_api_token_secret = var.pm_api_token_secret

  pm_tls_insecure = var.pm_tls_insecure
}

resource "proxmox_vm_qemu" "vm" {
  vmid = var.vm_id
  name  = var.vm_name
  target_node  = var.pm_host

  clone = var.vm_template

  memory   = var.vm_memory
  cores    = var.vm_cores
  sockets  = 1
  cpu      = "host"
  os_type  = "cloud-init"
  agent = 1

  disk {
    type     = "scsi"
    storage  = "local-lvm"
    size     = "${var.vm_disk_size}G"
    format   = "raw"
  }

  network {
    model   = "virtio"
    bridge  = "vmbr0"
    firewall = false
    macaddr = "52:54:00:00:00:${substr(var.vm_id,-2,-1)}"
  }

  network {
    model   = "virtio"
    bridge  = "vmbr2"
    firewall = false
    macaddr = "52:54:00:00:02:${substr(var.vm_id,-2,-1)}"
  }

  ipconfig0 = "${var.ip0}"

  ipconfig1 = "${var.ip1}"
}
