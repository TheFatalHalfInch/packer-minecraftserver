#!/bin/bash
#Constants
mcdir="/home/minecraft/minecraft"
#Time to sleep (intervals can be minutes, seconds, or otherwise)
tts="1m"
#Specify amount of RAM to run the server with
ram="8G"
DUMMYVAR="DUH"

#Changing to server directory
echo Changing directory...
cd ${mcdir}

#Enter loop to launch and verify whether server is running
while [ $DUMMYVAR = "DUH" ]
do 
  #Checks to see if java is running
  ps -C java > /dev/null

  #If java isn't running...
  if [ $? -ne 0 ]
  then
    echo Launching server...
    java -Xms"$ram" -Xmx"$ram" -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AlwaysPreTouch -jar server.jar > /dev/null 2>&1 & disown

  #If java is running...
  else
    echo Server already running...
  fi

  #Wait for specified amount of time before checking again
  sleep "$tts"
done
