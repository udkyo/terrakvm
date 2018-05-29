#!/bin/sh

ln -s /libvirt-sock /var/run/libvirt/libvirt-sock || sleep 0

exec "$@"
