resource "libvirt_volume" "terraform-gpu-base-qcow2" {
  name = "gpu.img"
  pool = "default"
  source = "./result/nixos.img"
  format = "raw"
}

resource "libvirt_volume" "terraform-gpu-qcow2" {
  name = "terraform-gpu.qcow2"
  pool = "default"
  format = "qcow2"
  size = 50000000000
  base_volume_id = libvirt_volume.terraform-gpu-base-qcow2.id
}

resource "libvirt_domain" "terraform-gpu" {
  name   = "terraform-gpu"
  memory = "16384"
  vcpu   = 8
  autostart = false
  qemu_agent = false

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
