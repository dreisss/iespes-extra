#!/bin/bash

sudo ifconfig enp2s0 192.168.3.$(($1 + 1))/24
sudo route add default gw 192.168.3.2

sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install virtualbox virtualbox-ext-pack -y

wget -O /usr/share/backgrounds/wallpaper.png https://raw.githubusercontent.com/dreisss/iespes-extra/main/design/wallpapers/wallpaper.png
gsettings set org.gnome.desktop.background picture-uri "/usr/share/backgrounds/wallpaper.png" 

gsettings set org.gnome.desktop.session idle-delay 900
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 3600

sudo adduser aluno
