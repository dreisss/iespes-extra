#!/bin/bash

if [ $(nmcli d s | grep " connected" | wc -l) != 1 ]
then
  nmcli c m "Wired connection 1" ipv4.addresses "192.168.3.$(($1 + 1))/24"
  nmcli c m "Wired connection 1" ipv4.gateway "192.168.3.1"
  nmcli c m "Wired connection 1" ipv4.dns "8.8.8.8"
  nmcli c m "Wired connection 1" ipv4.method "manual"
  nmcli c u "Wired connection 1"
fi

sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install virtualbox virtualbox-ext-pack -y

wget -O ~/Imagens/wallpaper.png https://raw.githubusercontent.com/dreisss/iespes-extra/main/design/wallpapers/wallpaper.png

