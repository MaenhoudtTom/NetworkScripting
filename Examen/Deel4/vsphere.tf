provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "StudentDatacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "maenhoudt-tom"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "StudentCluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "folder" {
  path          = "tom-maenhoudt"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "null_resource" "inline_command" {
  depends_on = [vsphere_virtual_machine.ubuntu, vsphere_virtual_machine.windows]
  provisioner "local-exec" {
    command = "ansible-playbook ansible-playbook.yml -i ansible-inventory.yml --ask-vault-pass"
  }
}