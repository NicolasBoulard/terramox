# Resource Definition for the VM Template
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
variable "domain" {
    type = string
}
variable "ssh_public_key" {
    type = string
}

# Executor IP address
variable "local_ip" {
    type = string
}

variable "local_port" {
    type = number
}

source "proxmox-clone" "k3s-template" {
    clone_vm = "debian-12-0-0-template"
    # Proxmox Connection Settings
    proxmox_url = "${var.pm_api_url}"
    username = "${var.pm_api_token_id}"
    token = "${var.pm_api_token_secret}"
    insecure_skip_tls_verify = "${var.pm_tls_insecure}"
    
    # VM General Settings
    node = "${var.pm_host}" # add your proxmox node
    vm_id = "90010"
    vm_name = "k3s-template"
    template_description = "K3s Template"

    # VM OS Settings
    

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "local-lvm"

    # disks {
    #     disk_size = "10G"
    #     format = "raw"
    #     storage_pool = "local-lvm"
    #     type = "virtio"
    # }

    # VM CPU Settings
    cores = "2"
    
    # VM Memory Settings
    memory = "4096" 

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    }

    # PACKER Boot Commands
    # boot_command = [
    #     "<wait><esc><wait>auto preseed/url=http://${var.local_ip}:${var.local_port}/preseed.cfg<enter>"
    # ]
    # boot = "c"
    # boot_wait = "5s"

    # # PACKER Autoinstall Settings
    # http_content = {
    #     "/preseed.cfg" = templatefile("${path.root}/../preseed/debian.cfg", {
    #         #packages = ["nginx"],
    #         username = var.guest_username,
    #         hostname = "debian-template",
    #         sshkey = var.ssh_public_key,

    #     })
    # }
    # (Optional) Bind IP Address and Port
    #http_bind_address = "0.0.0.0"
    # http_port_min = "${var.local_port}"
    # http_port_max = "${var.local_port}"


    ssh_host = "10.0.0.99"
    ssh_username = "${var.guest_username}"

    # (Option 1) Add your Password here
    #ssh_password = "password"
    # - or -
    # (Option 2) Add your Private SSH KEY file here
    ssh_private_key_file = "~/.ssh/id_rsa"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"
}
build {
    name = "k3s-template"
    sources = ["source.proxmox-clone.k3s-template"]

    provisioner "ansible" {
        only = ["proxmox-clone.k3s-template"]
        playbook_file = "../../ansible/playbooks/k3s-playbook.yml"
        #roles_path = "../../ansible/roles"
        user = var.guest_username
        ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_CONFIG=./ansible/ansible.cfg"]
        extra_arguments = ["--extra-vars", "prov_user=${var.guest_username}"]
        #ansible_ssh_common_args = ["-o", "ProxyJump=${var.guest_username}@${var.local_ip}"]
        #inventory_file_template = "{{ .HostAlias }} ansible_host={{ .Host }} ansible_user={{ .User }} ansible_port={{ .Port }}\n"
    }
}