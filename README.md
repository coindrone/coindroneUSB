CoinDrone
===

CoinDrone is a USB bootable Operating System used for mining coins (Bitcoins and Altcoins) using GPUs and etc. It is lightweight, stealthy, automated and fast.
**Currently in ALPHA, bugs are likely to happen. Feedback and suggestion are greatly appreciated**

## Features
CoinDrone is built upon Arch Linux and include 2 version, AMD and Nvidia in order to maximise compatiblity with all hardwares. It is currently built for X86_64 architechture only and uses cgminer for minting software.

#### Stealth:
The biggest feature of CoinDrone is how it operate to leave almost no trace on the running computer. The OS will run from RAM and take the config file from the CoinDrone USB drive only. Once rebooted (RAM is cleared), the computer will restart the default OS and no trace of CoinDrone remains.

Since CoinDrone runs from RAM, once the OS is loaded and started, you can then remove the USB drive and the OS will continue to work and mint. This is especialy useful if you don't have much access time to that computer, just plug, run, and leave with your drive. Also useful if you want to run on multiple computer, you just need to boot the drive and go to the next PC. Once you are done mining, just reboot the computer and default OS should boot like normal.

#### Lightweight and Fast:
CoinDrone only need 1Gb of space on a usb drive. Once booted, the system will take less than 1GB of Ram. 
It takes about 45 sec to a minute from the moment the drive is booted to the moment that you are minting coins.

#### Automation:
Once booted, CoinDrone will automaticaly start to mint coin. It will check for your USB drive (using the linux diskID) for a config file. If the config file exist, it will load that file for minting coins. Else, it will use the default config file and coin minted will be considered a donation. 

## Disclaimer
Running CoinDrone can and will damage your computer if you do not provide adequate airflow to the computer. CoinDrone will start mining automaticaly once started and will turn your GPUs to max. This will heat your card and may damage them if the heat is not taken care of. 
CoinDrone is released under the GNU GENERAL PUBLIC LICENSE. **I AM IN NO WAY reponsible of how you use CoinDrone** and the components and the damage it may cause to your Data, Hardware and other.
Running CoinDrone with the default configuration will mint coins for a Coindrone account. All coins mined this way will be considered as donation.

## Howto Use
#### Prepare USB Key
You will need a USB drive larger than 1GB. (all data will be erased when installing CoinDrone)

1. Download the latest image **[CoinDrone.v0.2-alpha.img](https://github.com/coindrone/coindroneUSB/releases/download/v0.2/CoinDrone.v0.2-alpha.img)** 
2. Download and unrar **[Win32diskimager](http://sourceforge.net/projects/win32diskimager/)**
3. Open Win32DiskImager and select both the .img and a UBS key larger than 1GB. Click "Write" to begin the transfer.
4. * (WARNING: Make sure that you select the right USB since this will erase all data on the USB)

The partition will also be of 1GB only. I order to expand that partition, use tools like partedmagic or any partition editor. **Warning: When doing modification of the CoinDrone partition, make sure that the DiskID is always : 0xa6c377d7. This value embedded in the ISOs and cannot be changed without recompiling.**

#### Config
**Note: If you boot your usb key now, the default config will be loaded and you will mine for the coindrone project. Make sure to edit the config file in order to mine for your account. Coins mined using the default config will be considered a donation to the project.**

Current config looks for CoinDrone USB key and for a config file on the root of the drive named : "CoinDrone.conf"

Edit the args variable to reflect your user settings:

* **--scrypt** (for LTC-litecoin mining)
* **-o** (is the host name of your pool.)
* **-u** (is the username)
* **-p** (is the password (leave Quotes+Backslash if empty, \"\" ))
* **-I** (intensity of mining)

## Howto Build
Follow instruction on github : [Howto-Build](https://github.com/coindrone/coindroneUSB/wiki/Howto-Build)

## Future of Coindrone.
Since the OS is currently in ALPHA, feature will be added in the near future and the software may change drastically. Please contact me if you have suggestion, bugs or else.

Here is a short list of expected features:
* Stealthier, make Coindrone impossible to login or redirect the clueless user.(reboot after too many attempt?)
* More configuration. 
* Download config from URL.
* Installation Script and Tutorial for persistent OS.

## About
Coindrone source code can be found here : https://github.com/coindrone/coindroneUSB
You can contact the coindrone admin at **coindroneminer [at] gmail [dot] com**

Please donate to get the project going:

* **BTC** : 1Dx5ZDXLHoipXqBZQGfv9Ko5HwDRn6ZHZS
* **LTC** : LaWTZc6Yw46d7zcm9qPtKL63G7dGbtriEP
* **NMC** : NCBzXMQvGFV9kZNCuHbwg6CEL29Ycp3sqU
