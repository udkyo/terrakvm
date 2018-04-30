provider "libvirt" {
    uri = "qemu:///system"
}

resource "null_resource" "terrakvm_null" {
  provisioner "local-exec" {
    command = "virsh pool-list | grep default"
  }
}

resource "libvirt_volume" "terrakvm_vol" {
    name = "terrakvm-test-vol"
    pool = "default"
}

