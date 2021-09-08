#!/bin/bash

#update open-vm-tools
apt-get -y install open-vm-tools

#disable cloud-init to allow cloning from vsphere template
touch /etc/cloud/cloud-init.disabled

apt-get -y update
apt-get -y upgrade