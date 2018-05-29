# TerraKVM

An Alpine based Docker container running [Terraform](https://github.com/hashicorp/terraform) and [terraform-libvirt-provider](https://github.com/dmacvicar/terraform-provider-libvirt).

## Usage

Mount a path containing your .tf files, and also your libvirt socket at /libvirt-sock.

`docker run --name terraform -it -v /var/run/libvirt/libvirt-sock:/libvirt-sock -v /path/to/tf/files:/terraform udkyo/terrakvm sh`

Optionally, mount paths to pool storage locations etc if you plan to manipulate files manually.