
# Welcome!

This is a packer template i've been working on for creating a minecraft server on a vSphere instance. 

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