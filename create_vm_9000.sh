#!/bin/bash

echo "ceate_vm_9000.sh started..."

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# example if you need to inject a key into the image
# FILE1=/root/ansible_ssh_key.txt
# if test -f "$FILE1"; then
#    echo "found ansible ssh key file..."
#  else
#    echo "could not find /root/anible_ssh_key.txt file.  Please create this file. exiting."
#    exit
# fi

FILE2=/root/jammy-server-cloudimg-amd64.img.original
if test -f "$FILE2"; then
     echo "found img file skipping download..."
     cp /root/jammy-server-cloudimg-amd64.img.original /root/jammy-server-cloudimg-amd64.img
else
     echo "downloading img file..."
     cd /root/
     wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
fi

virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent
virt-customize -a jammy-server-cloudimg-amd64.img --run-command "useradd -m -s /bin/bash ubuntu"
virt-customize -a jammy-server-cloudimg-amd64.img --root-password password:ubuntu
# virt-customize -a jammy-server-cloudimg-amd64.img --ssh-inject ubuntu:file:/root/ansible_ssh_key.txt
qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
qm set 9000 --scsi0 local-lvm:0,import-from=/root/jammy-server-cloudimg-amd64.img
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot order=scsi0
qm set 9000 --serial0 socket --vga serial0
qm set 9000 -agent 1
qm template 9000

echo "cerate_vm_9000 completed."
