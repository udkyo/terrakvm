#!/bin/sh

ln -s /libvirt-sock /var/run/libvirt/libvirt-sock

exec "$@"
