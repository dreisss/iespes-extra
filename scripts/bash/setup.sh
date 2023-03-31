#!/bin/bash

sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

sudo ifconfig enp2s0 192.168.3.$(($1 + 1))/24
sudo route add default gw 192.168.3.2

sudo apt install virtualbox virtualbox-ext-pack -y
