
# Welcome!

This is a packer template i've been working on for creating a minecraft server on a vSphere instance.  
This is for a vanilla Minecraft server with no modding or any kind of secondary software used.

## Requirements

- Packer (https://www.packer.io/downloads)
- A vSphere environment

## How to use this template

- Clone the repo
- Create a pkrvars.hcl file with your variables somewhere on your computer
- CD into the cloned directory  
    packer build --var-file="c:\path\to\your\pkrvars.hcl" MinecraftServer-20.04.pkr.hcl

## Acknowledgements

https://bobcares.com/blog/install-minecraft-server-on-ubuntu/ (guide for configuring minecraft server)  
https://louwrentius.com/understanding-the-ubuntu-2004-lts-server-autoinstaller.html (subiquity installation help)  
https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/ (minecraft server optimizations)  
https://www.spigotmc.org/threads/guide-server-optimization%E2%9A%A1.283181/ (minecraft server optimizations)  
https://travislawrence.co/2016/06/09/creating-vms-with-packer-and-vagrant/  
https://github.com/boxcutter/ubuntu/blob/master/script/desktop.sh (used the ubuntu.json template to get the sudo script syntax)  