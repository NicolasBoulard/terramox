
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
    default = "hodor"
}

module "vm" {
  source = "../../modules/vm"

  # Proxmox api connection details
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure
  pm_host             = var.pm_host
  
  vm_id        = 100
  vm_name      = "bastion"
  vm_template  = "bastion-template"
  vm_disk_size = 30
  vm_memory    = 2048
  vm_cores     = 4

  ip0 = "ip=10.0.0.100/24,gw=10.0.0.1"
  ip1 = "ip=10.100.0.100/24"
}

