CoinDrone
===

CoinDrone is a USB bootable Operating System used for mining coins (Bitcoins and Altcoins) using GPUs and etc. It is lightweight, stealthy, automated and fast.

## Features
CoinDrone is built upon Arch Linux and include 2 version, AMD and Nvidia in order to maximise compatiblity with all hardwares. It is currently built for X86_64 architechture only and uses cgminer for minting software.

Stealth:
The biggest feature of CoinDrone is how it operate to leave almost no trace on the running computer. The OS will run from RAM and take the config file from the CoinDrone USB drive only. Once rebooted (RAM is cleared), the computer will restart the default OS and no trace of CoinDrone remains.
Since CoinDrone runs from RAM, once the OS is loaded and started, you can then remove the USB drive and the OS will continue to work and mint. This is especialy useful if you don't have much access time to that computer, just plug, run, and leave with your drive. Also useful if you want to run on multiple computer, you just need to boot the drive and go to the next PC. Once you are done mining, just reboot the computer and default OS should boot like normal.

Lightweight and Fast:
CoinDrone only need 1Gb of space on a usb drive. Once booted, the system will take less than 1GB of Ram. 
It takes about 30-45 sec from the moment the drive is booted to the moment that you are minting coins.

Automation:
Once booted, CoinDrone will automaticaly start to mint coin (after the beep). It will check for your USB drive if a config file. If the config file exist, it will load that file for minting coins. Else, it will use the default config file and coin minted will be considered a donation. 

## Disclaimer
Running CoinDrone can and will damage your computer if you do not provide adequate airflow to the computer. CoinDrone will start mining automaticaly once started and will turn your GPUs to max. This will heat your card and may damage them if the heat is not taken care of. I AM IN NO WAY reponsible of how you use CoinDrone and the components and the damage it may cause to your Data, Hardware and other.
Running CoinDrone with the default configuration will mint coins for a Coindrone account. All coins mined this way will be considered as donation and won't be returned to the user.

## Install
Download the latest version. 

On Windows: Download Win32diskimager
Select the USB and the image and click write.

## Config
Current config looks for CoinDrone USB key and for a config file on the root of the drive named : "CoinDrone.conf"
Edit the args variable to reflect your user settings.

-o "is the host name of your pool."
-u "is the username"
-p "is the password (leave Quotes+Backslash if empty)"

## Future of Coindrone.
Since the OS is currently in ALPHA, feature will be added in the near future and the software may change drasticly. Please contact me if you ahve suggestion, bugs or else.

Here is a short list of expected features:
-Stealthier, make Coindrone impossible to login or redirect the clueless user.
-More configuration. 
-Installation Script and Tutorial for persistent OS.

## About
Coindrone source code can be found here : https://github.com/coindrone/coindroneUSB
You can contact the coindrone admin at coindrone [at] gmail [dot] com

Please donate to get the project going:
BTC : 1Dx5ZDXLHoipXqBZQGfv9Ko5HwDRn6ZHZS
LTC : LaWTZc6Yw46d7zcm9qPtKL63G7dGbtriEP
NMC : NCBzXMQvGFV9kZNCuHbwg6CEL29Ycp3sqU
