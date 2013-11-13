#!/bin/bash
#CoinDrone

#General Configs
diskID="0xa6c377d7"
confFile="CoinDrone.conf"
logFile="/var/log/CoinDrone.log"

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
    echo "mount" >>$logFile    

    if [ -f /root/coindroneusb/${confFile} ]; then
      source /root/coindroneusb/${confFile}
    else
      echo "Warning: No conf file found on USB drive." >>$logFile
      source /root/${confFile}
    fi
    
    umount /root/coindroneusb    
    echo "umount" >>$logFile

  else
    echo "Warning: Didn't find the USB Drive." >>$logFile
    source /root/CoinDrone.conf
  fi  
  
  echo "Installing cgminer." >>$logFile
  pacman -U --noconfirm ~/cgminer-3.7.2-1-x86_64.pkg.tar.xz
  echo "Starting CoinDrone." >>$logFile
  sleep 10
  screen -dmS coindrone cgminer ${cgminerargs} 
 
else
  echo "Warning: Program is already started." >>$logFile
fi

beep
