#!/bin/bash

echo "### Manjaro Post Install ###"

if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo, sudo ./run.sh"
    exit
fi

read -p '>>> What hostname should we use for this machine?: ' hostname
if [[ -z "$hostname" ]]; then
    printf '%s\n' "No hostname entered"
    exit 1
else
    printf "You entered %s " "$hostname"
    hostnamectl set-hostname $hostname
    echo ""
fi

sudo pacman-mirrors --fasttrack
sudo pacman -Syy

echo ">>> Enable TRIM (SSD only)"
sudo systemctl enable fstrim.timer

echo ">>> Enable File Limits!"
echo fs.nr_open=2147483584 | tee /etc/sysctl.d/40-max-user-watches.conf
echo fs.file-max=100000 | tee /etc/sysctl.d/40-max-user-watches.conf
echo fs.inotify.max_user_watches=524288 | tee /etc/sysctl.d/40-max-user-watches.conf

echo ">>> Make .ssh folder for keys, make 4096 ssh keys, add authorized_key file and chmod!"
mkdir ~/.ssh
HOSTNAME=$(hostname) ssh-keygen -t rsa -b 4096 -C "$HOSTNAME" -f "$HOME/.ssh/id_rsa" -P "" && cat ~/.ssh/id_rsa.pub
touch ~/.ssh/authorized_keys
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*
cp -r /root/.ssh /home/$u/
chown $u:$u /home/$u/.ssh -R

echo ">>> Enabling snap in package manager"
yes | pacman -Sy pamac-snap-plugin
1 | pacman -Sy --noconfirm pamac-flatpak-plugin

echo ">>> Install Packages"
yes | pacman -Syu base-devel git whois gnome-disk-utility
yes | pacman -Syu yay

echo ">>> Update packages"
yay -Syu

echo ">>> Install google-chrome"
yay -S google-chrome
