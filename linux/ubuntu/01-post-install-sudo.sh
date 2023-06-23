#!/bin/bash

source "./post-install-lib.sh"

p_h2 "### Ubuntu Post Install 01 ###"

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

#p_h2 "Make .ssh folder for keys, make 4096 ssh keys, add authorized_key file and chmod!"
#mkdir /home/$u/.ssh
#HOSTNAME=$(hostname) ssh-keygen -t rsa -b 4096 -C "$HOSTNAME" -f "/home/$u/.ssh/id_rsa" -P "" && cat /home/$u/.ssh/id_rsa.pub
#touch /home/$u/.ssh/authorized_keys
#chmod 700 /home/$u/.ssh && chmod 600 /home/$u/.ssh/*
#cp -r /root/.ssh /home/$u/
#chown $u:$u /home/$u/.ssh -R

p_h2 "Install Apt Install Packages"
input="./apt-packages.conf"
while IFS='=' read -r lineDesc lineApp
do
  if [[ "$lineDesc" =~ ^[^#].* ]]; then
    if [[ ! -z $lineApp ]]; then
      p_h2 "Install $lineDesc"
      apt install -y $lineApp
    fi
  fi
done < "$input"

CHSH='yes'
RUNZSH='no' 
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

cp /home/$u/.zshrc /home/$u/.zshrc-bkp
cp .zshrc /home/$u/.zshrc


# ### BEGIN: NEED TESTS

# sudo usermod -s /usr/bin/zsh $(whoami)


# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak install -y flathub com.mattjakeman.ExtensionManager

# ### END:   NEED TESTS

# p_h1 "### To continue Restart and Execute"
# echo "./xxx.sh"
p_br
p_br

