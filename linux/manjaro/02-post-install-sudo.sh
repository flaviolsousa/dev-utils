#!/bin/bash

source "./post-install-lib.sh"

p_h2 "### Manjaro Post Install 02 ###"

u=$(logname)
p_prop u $u
p_br

if [ "$EUID" -ne 0 ]; then
  p_error "Please run WITH sudo"
  p_error "sudo ./02-post-install-sudo.sh"
  p_br
  exit
fi

read -p "Press enter to continue"

p_h2 "Enabling Snap"
pacman -Sy snapd pamac-snap-plugin --noconfirm
1 | pacman -Sy --noconfirm pamac-flatpak-plugin

pacman -S snapd

systemctl enable --now snapd.socket
systemctl enable --now snapd.apparmor

p_h2 "Install Snap Packages"
input="./snap-packages.conf"
while IFS= read -r line
do
  if [[ "$line" =~ ^[^#].* ]]; then
    if [[ ! -z $line ]]; then
      p_h2 "Install $line"
      snap install $line
    fi
  fi
done < "$input"

p_h1 "### To continue execute"
echo "./03-post-install.sh"

