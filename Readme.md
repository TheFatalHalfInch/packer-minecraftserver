
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

https://bobcares.com/blog/install-minecraft-server-on-ubuntu/
https://louwrentius.com/understanding-the-ubuntu-2004-lts-server-autoinstaller.html
https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
https://www.spigotmc.org/threads/guide-server-optimization%E2%9A%A1.283181/