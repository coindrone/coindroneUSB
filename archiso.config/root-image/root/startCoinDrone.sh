#!/bin/bash
#CoinDrone

#General Configs
diskID="0xa6c377d7"
confFile="CoinDrone.conf"
logFile="/root/CoinDrone.log"
logFileminer="/root/CoinDrone-cgminer.log"

touch ${logFile}
touch ${logFileminer}

#Check if the program is already started and start it. 
if [ -z $(pgrep -u root cgminer) ]; then

  #Find the USB Drive.
  usbdrivepart=`fdisk -l | grep -A3 ${diskID} | grep /dev/sd | cut -c 1-9`
  
  if [ -n ${usbdirvepart} ]; then

    #Create mount folder if it doesn't exist.
    if [ ! -d /root/coindroneusb ]; then
      mkdir /root/coindroneusb
    fi
    
    mount ${usbdrivepart} /root/coindroneusb
    echo "Mounting USB" >>$logFile    

    if [ -f /root/coindroneusb/${confFile} ]; then
      cp -rf /root/coindroneusb/${confFile} /root/${confFile}
    else
      echo "Warning: No conf file found on USB drive." >>$logFile
    fi
    
    umount /root/coindroneusb    
    echo "Unmounting USB" >>$logFile

  else
    echo "Warning: Didn't find the USB Drive. Loading Default config file." >>$logFile
  fi  
  
  #Loading Config File.
  if [ -f /root/${confFile} ]; then
    source /root/${confFile}
  else
    source /root/CoinDrone.conf
  fi
  
  if [ ! -f /usr/bin/cgminer ]; then
    echo "cgminer not found. Installing..." >>$logFile
    pacman -U --noconfirm ~/cgminer-3.7.2-1-x86_64.pkg.tar.xz >>$logFile
    echo "Install complete." >>$logFile
  fi
  
  #Wait 10 sec for network dhcp connection and other services.
  sleep 10
  
  echo "Starting CoinDrone." >>$logFile
  screen -dmS coindrone cgminer ${cgminerargs} 2>/root/CoinDrone-cgminer.log
 
else
  echo "Warning: Program is already started." >>$logFile
fi