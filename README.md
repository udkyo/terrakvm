# TerraKVM

An Alpine based Docker container running [Terraform](https://github.com/hashicorp/terraform) and [terraform-libvirt-provider](https://github.com/dmacvicar/terraform-provider-libvirt).

## Usage

Pass in your UID/GID, mount a path containing your .tf files, and also your libvirt socket at /libvirt-sock.

`docker run --name terraform -it -e PGID=$(id -g) -e PUID=$(id -u) -v /var/run/libvirt/libvirt-sock:/libvirt-sock -v /path/to/tf/files:/terraform udkyo/terrakvm sh`

Optionally, mount paths to pool storage locations etc if you plan to manipulate files manually.

## Notes

Virsh changes permissions of files to root:root, the user in the container is a sudoer so you can (for instance) define an inline script which runs `virsh destroy [VM]` (thus changing the target's disks to root:root) followed by `sudo qemu-img resize` to manipulate volume sizes in your plans, post-build.