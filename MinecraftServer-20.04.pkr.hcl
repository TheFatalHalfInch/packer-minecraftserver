variable "cpus" {
  type    = number
  default = 1
}

variable "cpu_cores" {
  type = number
  default = 1
}

variable "disk_size" {
  type    = number
  default = 10000
}

variable "ssh_wait" {
  type = string
  default = "5m"
}

variable "insecure_connection" {
  type    = bool
  default = false
}

variable "iso_checksum" {
  type    = string
  default = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
}

variable "iso_url" {
  type    = string
  default = "http://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso"
}

variable "iso_paths" {
  type    = list(string)
  default = [""]
}

variable "memory" {
  type    = number
  default = 1024
}

variable "name" {
  type    = string
  default = "MinecraftServer-20.04"
}

variable "vcenter_cluster" {
  type    = string
  default = ""
}

variable "vcenter_datastore" {
  type    = string
  default = ""
}

variable "vcenter_folder" {
  type    = string
  default = ""
}

variable "vcenter_network" {
  type    = string
  default = ""
}

variable "vcenter_password" {
  type    = string
  default = ""
}

variable "vcenter_server" {
  type    = string
  default = ""
}

variable "convert_template" {
  type    = bool
  default = false
}

variable "vcenter_username" {
  type    = string
  default = ""
}

variable "http_directory" {
  type = string
  default = ""
}

variable "ssh_password" {
  type = string
  default = "ubuntu"
}

source "vsphere-iso" "autogenerated_1" {
  boot_command        = [
    "<esc><enter><f6><esc>",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<enter>",
    "<wait${var.ssh_wait}>"
  ]
  boot_wait           = "5s"
  cluster             = "${var.vcenter_cluster}"
  convert_to_template = "${var.convert_template}"
  CPUs                = "${var.cpus}"
  cpu_cores = "${var.cpu_cores}"
  datastore           = "${var.vcenter_datastore}"
  folder              = "${var.vcenter_folder}"
  guest_os_type       = "ubuntu64Guest"
  notes = "${formatdate("MMM DD YYYY hh:mm ZZZ","${timestamp()}")}"
  http_directory      = "${var.http_directory}"
  cdrom_type = "sata"
  insecure_connection = "${var.insecure_connection}"
  iso_checksum        = "${var.iso_checksum}"
  #iso_url             = "${var.iso_url}"
  iso_paths = "${var.iso_paths}"
  network_adapters {
    network      = "${var.vcenter_network}"
    network_card = "vmxnet3"
  }
  password         = "${var.vcenter_password}"
  RAM              = "${var.memory}"
  ssh_password     = "${var.ssh_password}"
  ssh_timeout      = "30m"
  ssh_username     = "ubuntu"
  disk_controller_type = ["lsilogic-sas"]
  storage {
    disk_size = "${var.disk_size}"
    disk_thin_provisioned = true
  }
  username       = "${var.vcenter_username}"
  vcenter_server = "${var.vcenter_server}"
  vm_name        = "${var.name}"
}

build {
  sources = ["source.vsphere-iso.autogenerated_1"]

  provisioner "file" {
    source = "${path.root}/scripts"
    destination = "~/"
  }

  provisioner "shell" {
    execute_command   = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    inline = [
      "cp ~/scripts/minecraft.service /etc/systemd/system/minecraft.service",
      "cp ~/scripts/minecraftserverbackup /etc/cron.daily/minecraftserverbackup",
      "rm -R ~/scripts"
    ]
  }

  provisioner "shell" {
    execute_command   = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    script = "${path.root}/scripts/config.sh"
  }
}