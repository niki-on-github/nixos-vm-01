resource "libvirt_volume" "terraform-gpu-base-qcow2" {
  name = "gpu.qcow2"
  pool = "default"
  source = "./gpu.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "terraform-gpu-qcow2" {
  name = "terraform-gpu.qcow2"
  pool = "default"
  format = "qcow2"
  size = 40000000000
  base_volume_id = libvirt_volume.terraform-gpu-base-qcow2.id
}

resource "libvirt_domain" "terraform-gpu" {
  name   = "terraform-gpu"
  memory = "4096"
  vcpu   = 6
  autostart = false
  qemu_agent = true
  firmware = "efi"

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
     network_name = "default"  
  }

  xml {
    xslt = "${file("gpu.xslt")}"
  }
  
  disk {
    volume_id = "${libvirt_volume.terraform-gpu-qcow2.id}"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
}
