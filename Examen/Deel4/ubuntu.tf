data "vsphere_virtual_machine" "ubuntu-tpl" {
  name          = "ubuntu-template-examen"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "ubuntu" {
  name             = "tom-ubu"
  folder           = "tom-maenhoudt"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = "4"
  memory   = "2GB"
  guest_id = data.vsphere_virtual_machine.ubuntu-tpl.guest_id

  scsi_type = data.vsphere_virtual_machine.ubuntu-tpl.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.ubuntu-tpl.network_interface_types
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.ubuntu-tpl.disks.size
    eagerly_scrub    = data.vsphere_virtual_machine.ubuntu-tpl.disks.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.ubuntu-tpl.disks.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu-tpl.id

    customize {
      linux_options {
        host_name = "tom-ubu"
        domain    = "lab.local"
      }

      network_interface {
        ipv4_address = "192.168.40.50"
        ipv4_netmask = 24
      }

      ipv4_gateway    = "192.168.40.1"
      dns_server_list = ["192.168.40.1"]
    }
  }
}