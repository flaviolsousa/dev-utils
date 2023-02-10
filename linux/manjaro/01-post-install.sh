#!/bin/bash

echo "### Manjaro Post Install 01 ###"

u=$(logname)
echo u=$u

if [ "$EUID" -ne 0 ]; then
  echo "Please run WITH sudo, sudo ./run.sh"
  echo "sudo ./01-post-install.sh"
  exit
fi

read -p "Press enter to continue"

sudo usermod -aG root -a $USER
sudo usermod -aG wheel -a $USER
cat >> /etc/sudoers <<<"$u  ALL=(ALL:ALL) NOPASSWD:ALL"

sudo pacman-mirrors --fasttrack
sudo pacman -Syy

echo -e "\n\n >>> Enable TRIM (SSD only) \n"
sudo systemctl enable fstrim.timer

echo -e "\n\n >>> Enable File Limits \n"
echo fs.nr_open=2147483584 | tee /etc/sysctl.d/40-max-user-watches.conf
echo fs.file-max=100000 | tee /etc/sysctl.d/40-max-user-watches.conf
echo fs.inotify.max_user_watches=524288 | tee /etc/sysctl.d/40-max-user-watches.conf

#echo -e "\n\n >>> Make .ssh folder for keys, make 4096 ssh keys, add authorized_key file and chmod! \n"
#mkdir /home/$u/.ssh
#HOSTNAME=$(hostname) ssh-keygen -t rsa -b 4096 -C "$HOSTNAME" -f "/home/$u/.ssh/id_rsa" -P "" && cat /home/$u/.ssh/id_rsa.pub
#touch /home/$u/.ssh/authorized_keys
#chmod 700 /home/$u/.ssh && chmod 600 /home/$u/.ssh/*
#cp -r /root/.ssh /home/$u/
#chown $u:$u /home/$u/.ssh -R

echo -e "\n\n >>> Enabling snap in package manager \n"
pacman -Sy pamac-snap-plugin --noconfirm
1 | pacman -Sy --noconfirm pamac-flatpak-plugin

echo -e "\n\n >>> Install Packages \n"
pacman -Syu whois gnome-disk-utility --noconfirm

echo -e "\n\n >>> Install yay \n"
pacman -S yay --noconfirm

echo -e "\n\n >>> Force colors in terminals \n"
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /root/.bashrc
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/$u/.bashrc

echo -e "\n\n >>> Update packages \n"
yay -Syu

echo -e "\n\n ### To continue execute: \n"
echo "./02-post-install.sh"

