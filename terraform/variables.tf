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

# Others
variable "pm_host" {
    default = "hodor"
}

# Guest VM details
variable "guest_username" {
    type = string
}
