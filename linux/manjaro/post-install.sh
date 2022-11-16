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

echo -e "\n >>> Enable TRIM (SSD only)"
sudo systemctl enable fstrim.timer

echo -e "\n >>> Enable File Limits"
echo fs.nr_open=2147483584 | tee /etc/sysctl.d/40-max-user-watches.conf
echo fs.file-max=100000 | tee /etc/sysctl.d/40-max-user-watches.conf
echo fs.inotify.max_user_watches=524288 | tee /etc/sysctl.d/40-max-user-watches.conf

echo -e "\n >>> Make .ssh folder for keys, make 4096 ssh keys, add authorized_key file and chmod!"
mkdir ~/.ssh
HOSTNAME=$(hostname) ssh-keygen -t rsa -b 4096 -C "$HOSTNAME" -f "$HOME/.ssh/id_rsa" -P "" && cat ~/.ssh/id_rsa.pub
touch ~/.ssh/authorized_keys
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*
cp -r /root/.ssh /home/$u/
chown $u:$u /home/$u/.ssh -R

echo -e "\n >>> Enabling snap in package manager"
pacman -Sy pamac-snap-plugin --noconfirm
1 | pacman -Sy --noconfirm pamac-flatpak-plugin

echo -e "\n >>> Install Packages"
pacman -Syu whois gnome-disk-utility --noconfirm

echo -e "\n >>> Install yay"
mkdir ~/apps
cd ~/apps
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
pacman -S --needed git base-devel yay

echo -e "\n >>> Force colors in terminals"
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /root/.bashrc
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/$(cat user.log)/.bashrc

echo -e "\n >>> Update packages"
yay -Syu

echo -e "\n >>> Install google-chrome"
yay -S google-chrome

echo -e "\n >>> Install google-chrome"
