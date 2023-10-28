

resource "proxmox_vm_qemu" "k3s-server" {
    vmid = 101
    name  = "k3s-server"
    target_node  = var.pm_host

    clone = "k3s-template"

    memory   = 4096
    cores    = 4
    sockets  = 1
    cpu      = "host"
    os_type  = "cloud-init"
    agent = 1

    scsihw = "virtio-scsi-pci"

    disk {
        type     = "scsi"
        storage  = "local-lvm"
        size     = "30G"
        format   = "raw"
    }

    network {
        model   = "virtio"
        bridge  = "vmbr1"
        firewall = false
        tag = 100
        macaddr = "52:54:01:00:02:00"
    }
    ipconfig0 = "ip=10.100.0.200/24"

    network {
        model   = "virtio"
        bridge  = "vmbr0"
        firewall = false
        macaddr = "52:54:00:00:02:00"
    }
    ipconfig1 = "ip=10.0.0.200/24"
}

resource "proxmox_vm_qemu" "k3s-agent" {
    count = 3
    vmid = 102 + count.index
    name  = "k3s-agent-${count.index + 1}"
    target_node  = var.pm_host

    clone = "k3s-template"

    memory   = 4096
    cores    = 4
    sockets  = 1
    cpu      = "host"
    os_type  = "cloud-init"
    agent = 1

    scsihw = "virtio-scsi-pci"

    disk {
        type     = "scsi"
        storage  = "local-lvm"
        size     = "30G"
        format   = "raw"
    }

    network {
        model   = "virtio"
        bridge  = "vmbr1"
        firewall = false
        tag = 100
        macaddr = "52:54:01:00:02:0${count.index + 1}"
    }
    ipconfig0 = "ip=10.100.0.20${count.index + 1}/24"
}

# Generate Ansible inventory
# resource "local_file" "ansible_inventory" {
#   filename = "ansible_inventory.ini"
#   content = <<-EOT
#     [k3s]
#     ${join("\n", [for vm in var.vm_configs : "${vm.name} ansible_host=${proxmox_vm_qemu.vm[vm.name].ssh_host} ansible_user=nicolas"])}
#   EOT
# }


# resource "local_file" "inventory" {
#   filename = "inventory"
#   content  = <<-EOT
# [pve_kub_master]
# %{ for instance in proxmox_vm_qemu.vm_master ~}
# ${instance.name} ansible_host=${instance.ssh_host}
# %{ endfor ~}

# [pve_kub_worker]
# %{ for instance in proxmox_vm_qemu.vm_worker ~}
# ${instance.name} ansible_host=${instance.ssh_host}
# %{ endfor ~}
#   EOT
# }