#!/bin/bash

#update open-vm-tools
apt-get -y install open-vm-tools

#disable cloud-init to allow cloning from vsphere template
touch /etc/cloud/cloud-init.disabled

apt-get -y update
apt-get -y upgrade

#install java
sudo apt-get -y install openjdk-16-jre-headless

#create minecraft user
sudo useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft -p minecraft
sudo passwd -d minecraft
su minecraft
mkdir -p ~/{backups,tools,server}

#download minecraft server
wget https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar -P ~/server

#launch the server to generate files
cd ~/server
java -Xmx1024M -Xms1024M -jar server.jar nogui
sed -i 's/eula=false/eula=true/g' eula.txt
sed -i 's/enable-rcon=false/enable-rcon=true/g' server.properties
sed -i 's/rcon.password=/rcon.password=minecraft/g' server.properties

#install mrcon
curl -LJO https://github.com/Tiiffi/mcrcon/releases/download/v0.7.1/mcrcon-0.7.1-linux-x86-64.tar.gz

#configure minecraft server service