#!/bin/bash

echo "### Manjaro Post Install ###"

if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo, sudo ./run.sh"
    exit
fi

sudo pacman-mirrors --fasttrack
sudo pacman -Syy

echo -e "\n\n >>> Enable TRIM (SSD only) \n"
sudo systemctl enable fstrim.timer

echo -e "\n\n >>> Enable File Limits \n"
echo fs.nr_open=2147483584 | tee /etc/sysctl.d/40-max-user-watches.conf
echo fs.file-max=100000 | tee /etc/sysctl.d/40-max-user-watches.conf
echo fs.inotify.max_user_watches=524288 | tee /etc/sysctl.d/40-max-user-watches.conf

#echo -e "\n\n >>> Make .ssh folder for keys, make 4096 ssh keys, add authorized_key file and chmod! \n"
#mkdir ~/.ssh
#HOSTNAME=$(hostname) ssh-keygen -t rsa -b 4096 -C "$HOSTNAME" -f "$HOME/.ssh/id_rsa" -P "" && cat ~/.ssh/id_rsa.pub
#touch ~/.ssh/authorized_keys
#chmod 700 ~/.ssh && chmod 600 ~/.ssh/*
#cp -r /root/.ssh /home/$u/
#chown $u:$u /home/$u/.ssh -R

echo -e "\n\n >>> Enabling snap in package manager \n"
pacman -Sy pamac-snap-plugin --noconfirm
1 | pacman -Sy --noconfirm pamac-flatpak-plugin

echo -e "\n\n >>> Install Packages \n"
pacman -Syu whois gnome-disk-utility --noconfirm

echo -e "\n\n >>> Install yay \n"
mkdir ~/apps
cd ~/apps
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
pacman -S --needed git base-devel yay

echo -e "\n\n >>> Force colors in terminals \n"
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /root/.bashrc
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/$(cat user.log)/.bashrc

echo -e "\n\n >>> Update packages \n"
yay -Syu

echo -e "\n\n >>> Install new packages \n"
input="./yay-packages.txt"
while IFS='=' read -r lineDesc lineApp
do
  if [[ "$lineDesc" =~ ^[^#].* ]]; then
    echo -e "\n\n >>> Install $lineDesc"
    yay -S $lineApp --needed --noconfirm
  fi
done < "$input"

echo -e "\n\n >>> Install VSCode Extensions \n"
input="./vscode-extensions.txt"
while IFS= read -r line
do
  if [[ "$line" =~ ^[^#].* ]]; then
    echo -e "\n\n >>> vscode.ext = $line \n"
    code --install-extension $line
  fi
done < "$input"

echo -e "\n\n >>> Install Oh My ZSH \n"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k


# echo -e "\n\n >>> Config Jabba \n"
# jabba ls-remote
# jabba install openjdk@1.11.0-1

