#!/bin/bash
mchomedir="/opt/minecraft"

#update open-vm-tools
apt-get -y install open-vm-tools

#install jq (to automate getting the server.jar download url)
apt-get -y install jq

#disable cloud-init to allow cloning from vsphere template
touch /etc/cloud/cloud-init.disabled

apt-get -y update
apt-get -y upgrade

#install java
apt-get -y install openjdk-16-jre-headless

#create minecraft user
useradd -r -m -U -d "${mchomedir}" -s /bin/bash minecraft -p minecraft
mkdir -p "${mchomedir}/"{backups,tools,server}

#set the url to pull the json manifest file
URL='https://launchermeta.mojang.com/mc/game/version_manifest.json'
#store the json manifest file
MANIFEST=$(curl $URL)
#get the latest version number from the manifest file
LATEST=$(echo $MANIFEST | jq .latest.release --raw-output)
#find the url for the latest version's json file (contiains info for latest release)
LATESTURL=$(echo $MANIFEST | jq --arg LATEST "$LATEST" '.versions[] | select(.id == $LATEST).url' --raw-output)
#get the json info from the latest version and store the download link for the jar file
JAR=$(curl $LATESTURL | jq .downloads.server.url --raw-output)
#download the server jar file
wget $JAR -P "${mchomedir}/"server

#launch the server to generate files
cd "${mchomedir}/server"
java -Xmx1024M -Xms1024M -jar server.jar nogui

#edit server files to accept eula, enable rcon, and set rcon password
sed -i 's/eula=false/eula=true/g' "${mchomedir}/"server/eula.txt
sed -i 's/enable-rcon=false/enable-rcon=true/g' "${mchomedir}/"server/server.properties
sed -i 's/rcon.password=/rcon.password=minecraft/g' "${mchomedir}/"server/server.properties

#install mrcon
cd "${mchomedir}/"tools
curl -LJO https://github.com/Tiiffi/mcrcon/releases/download/v0.7.1/mcrcon-0.7.1-linux-x86-64.tar.gz
tar -xzvf mcrcon-0.7.1-linux-x86-64.tar.gz
cp "${mchomedir}/"tools/mcrcon-0.7.1-linux-x86-64/mcrcon "${mchomedir}/"tools/mcrcon
rm -R "${mchomedir}/"tools/mcrcon-*

#configure minecraft server service
#file is copied over during packer provisioning stage
systemctl daemon-reload
systemctl enable minecraft

#allow port in firewall
ufw allow 25565/tcp

#make backup script executable
#this is copied over as part of packer provisioning
chmod +x /etc/cron.daily/minecraftserverbackup

#change ownership of minecraft service account directory to minecraft user/group
chown -R minecraft:minecraft "${mchomedir}"