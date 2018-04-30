#!/bin/sh

adduser -D user
echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chown -R user:user /home/user

groupadd -for -g $(stat -c '%g' /libvirt-sock) libvirt
groupmod -o -g $(stat -c '%g' /libvirt-sock) libvirt
usermod -o -u "$PUID" user &>/dev/null
usermod -aG libvirt user &>/dev/null
groupmod -o -g "$PGID" user

ln -s /libvirt-sock /home/user/.cache/libvirt/libvirt-sock
ln -s /libvirt-sock /var/run/libvirt/libvirt-sock
chgrp -R user /var/run/libvirt

exec su -c "$@" user