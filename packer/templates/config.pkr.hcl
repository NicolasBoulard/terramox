packer {
    required_plugins {
        proxmox = {
            version = ">= 1.1.3"
            source  = "github.com/hashicorp/proxmox"
        }
        ansible = {
            source  = "github.com/hashicorp/ansible"
            version = "~> 1"
        }
    }
}
