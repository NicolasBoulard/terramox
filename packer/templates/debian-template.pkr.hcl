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

source "proxmox-iso" "debian-template" {
 
    # Proxmox Connection Settings
    proxmox_url = "${var.pm_api_url}"
    username = "${var.pm_api_token_id}"
    token = "${var.pm_api_token_secret}"
    insecure_skip_tls_verify = "${var.pm_tls_insecure}"
    
    # VM General Settings
    node = "${var.pm_host}" # add your proxmox node
    vm_id = "90001"
    vm_name = "debian-12-0-0-template"
    template_description = "Debian Template"

    # VM OS Settings
    # Iso file of debian 12 stable
    #iso_file = "monkey:iso/debian-12.0.0-amd64-netinst.iso"
    iso_url = "https://cdimage.debian.org/cdimage/archive/12.0.0/amd64/iso-cd/debian-12.0.0-amd64-netinst.iso"
    iso_checksum = "file:https://cdimage.debian.org/cdimage/archive/12.0.0/amd64/iso-cd/SHA256SUMS"

    # Download the ISO file directly from PVE
    iso_download_pve = true

    iso_storage_pool = "monkey"
    unmount_iso = true

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = "10G"
        format = "raw"
        storage_pool = "local-lvm"
        type = "scsi"
    }

    # VM CPU Settings
    cores = "2"
    
    # VM Memory Settings
    memory = "2048" 

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "local-lvm"

    # PACKER Boot Commands
    boot_command = [
        "<wait><esc><wait>auto preseed/url=http://${var.local_ip}:${var.local_port}/preseed.cfg<enter>"
    ]
    boot = "c"
    boot_wait = "5s"

    # PACKER Autoinstall Settings
    http_content = {
        "/preseed.cfg" = templatefile("${path.root}/../preseed/debian.cfg", {
            #packages = ["nginx"],
            username = var.guest_username,
            hostname = "debian-template",
            domain = var.domain,
            sshkey = var.ssh_public_key,

        })
    }
    # (Optional) Bind IP Address and Port
    #http_bind_address = "0.0.0.0"
    http_port_min = "${var.local_port}"
    http_port_max = "${var.local_port}"


    ssh_host = "10.0.0.99"
    ssh_username = "${var.guest_username}"

    # (Option 1) Add your Password here
    ssh_password = "password"
    # - or -
    # (Option 2) Add your Private SSH KEY file here
    #ssh_private_key_file = "~/.ssh/id_rsa"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"
}

source "proxmox-clone" "bastion-template" {
    clone_vm = "debian-12-0-0-template"
    # Proxmox Connection Settings
    proxmox_url = "${var.pm_api_url}"
    username = "${var.pm_api_token_id}"
    token = "${var.pm_api_token_secret}"
    insecure_skip_tls_verify = "${var.pm_tls_insecure}"
    
    # VM General Settings
    node = "${var.pm_host}" # add your proxmox node
    vm_id = "90002"
    vm_name = "bastion-template"
    template_description = "Bastion Template"

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
    memory = "2048" 

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    }
    network_adapters {
        model = "virtio"
        bridge = "vmbr2"
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

# Build Definition to create the VM Template
build {
    name = "debian-template"
    sources = ["source.proxmox-iso.debian-template"]

    # provisioner "shell" {
    #     inline = [
    #         "sudo apt-get update",
    #         "sudo apt-get install -y git"
    #     ]
    # }
    # provisioner "shell" {
    #     only = ["proxmox-iso.debian-template"]
    #     #execute_command = "ip -4 addr show dev ens18 | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}'"
    # }
    provisioner "ansible" {
        only = ["proxmox-iso.debian-template"]
        playbook_file = "../../ansible/playbooks/debian-template-playbook.yml"
        #roles_path = "../../ansible/roles"
        user = var.guest_username
        ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_CONFIG=./ansible/ansible.cfg"]
        extra_arguments = ["--extra-vars", "prov_user=${var.guest_username}"]
        #inventory_file_template = "{{ .HostAlias }} ansible_host={{ .Host }} ansible_user={{ .User }} ansible_port={{ .Port }}\n"
    }
    # provisioner "file" {
    #     source = "cloudinit/cloud-init.cfg"
    #     destination = "/etc/cloud/cloud.cfg"
    # }
    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    # provisioner "shell" {
    #     inline = [
    #         "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
    #         "sudo rm /etc/ssh/ssh_host_*",
    #         "sudo truncate -s 0 /etc/machine-id",
    #         "sudo apt -y autoremove --purge",
    #         "sudo apt -y clean",
    #         "sudo apt -y autoclean",
    #         "sudo cloud-init clean",
    #         "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
    #         "sudo sync"
    #     ]
    # }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    # provisioner "file" {
    #     source = "files/99-pve.cfg"
    #     destination = "/tmp/99-pve.cfg"
    # }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    # provisioner "shell" {
    #     inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    # }

    # Provisioning the VM Template with Docker Installation #4
    # provisioner "shell" {
    #     inline = [
    #         "sudo apt-get install -y ca-certificates curl gnupg lsb-release",
    #         "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
    #         "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
    #         "sudo apt-get -y update",
    #         "sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
    #     ]
    # }
}
build {
    name = "bastion-template"
    sources = ["source.proxmox-clone.bastion-template"]

    provisioner "ansible" {
        only = ["proxmox-clone.bastion-template"]
        playbook_file = "../../ansible/playbooks/bastion-playbook.yml"
        #roles_path = "../../ansible/roles"
        user = var.guest_username
        ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_CONFIG=./ansible/ansible.cfg"]
        extra_arguments = ["--extra-vars", "prov_user=${var.guest_username}"]
        #inventory_file_template = "{{ .HostAlias }} ansible_host={{ .Host }} ansible_user={{ .User }} ansible_port={{ .Port }}\n"
    }
}