variable "vsphere_user" {
  type        = string
  description = "Vcenter vSphere user"
  sensitive = true
}

variable "vsphere_password" {
  type        = string
  description = "Password for user"
  sensitive = true
}

variable "vsphere_server" {
  type        = string
  default     = "192.168.50.10"
  description = "IP-address of vCenter"
}

variable "vm_hostname" {
  type = string
  default = "webserver"
  description = "Name of the virtual machines"
}

variable "ubuntu_pass" {
  type = string
  description = "Password for template"
}

variable "vm_user" {
  type = string
  default = "student"
}
variable "vm_pwd" {
  type = string
}