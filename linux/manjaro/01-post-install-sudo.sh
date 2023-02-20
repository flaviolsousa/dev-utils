#!/bin/bash

source "./post-install-lib.sh"

p_h2 "### Manjaro Post Install 01 ###"

u=$(logname)
p_prop u $u
p_br

if [ "$EUID" -ne 0 ]; then
  p_error "Please run WITH sudo"
  p_error "sudo ./01-post-install-sudo.sh"
  p_br
  exit
fi

read -p "Press enter to continue"

p_br
p_h2 "Add current user to sudoers"
sudo usermod -aG root -a $USER
sudo usermod -aG wheel -a $USER
cat >> /etc/sudoers <<<"$u  ALL=(ALL:ALL) NOPASSWD:ALL"

sudo pacman-mirrors --fasttrack
sudo pacman -Syy

p_h2 "Enable TRIM (SSD only)"
sudo systemctl enable fstrim.timer

p_h2 "Enable File Limits"
echo fs.nr_open=2147483584 | tee /etc/sysctl.d/40-max-user-watches.conf
echo fs.file-max=100000 | tee /etc/sysctl.d/40-max-user-watches.conf
echo fs.inotify.max_user_watches=524288 | tee /etc/sysctl.d/40-max-user-watches.conf

#p_h2 "Make .ssh folder for keys, make 4096 ssh keys, add authorized_key file and chmod!"
#mkdir /home/$u/.ssh
#HOSTNAME=$(hostname) ssh-keygen -t rsa -b 4096 -C "$HOSTNAME" -f "/home/$u/.ssh/id_rsa" -P "" && cat /home/$u/.ssh/id_rsa.pub
#touch /home/$u/.ssh/authorized_keys
#chmod 700 /home/$u/.ssh && chmod 600 /home/$u/.ssh/*
#cp -r /root/.ssh /home/$u/
#chown $u:$u /home/$u/.ssh -R

p_h2 "Install Packages"
pacman -Syu whois gnome-disk-utility --noconfirm

p_h2 "Install yay"
pacman -S yay --noconfirm

p_h2 "Force colors in terminals"
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /root/.bashrc
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/$u/.bashrc

p_h2 "Update packages"
yay -Syu

p_h2 "Changing Shell to zsh"
chsh -s $(which zsh) $u
chsh -s $(which zsh)

p_h2 "Enabling Snap"
pacman -Sy snapd pamac-snap-plugin --noconfirm
1 | pacman -Sy --noconfirm pamac-flatpak-plugin

pacman -S snapd

systemctl enable --now snapd.socket
systemctl enable --now snapd.apparmor

p_h1 "### To continue Restart and Execute"
echo "sudo ./02-post-install-sudo.sh"
