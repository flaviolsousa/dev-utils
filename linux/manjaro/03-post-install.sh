#!/bin/bash

source "./post-install-lib.sh"

p_h1 "### Manjaro Post Install 03 ###"

u=$(logname)
p_prop u $u
p_br

if [ "$EUID" -eq 0 ]; then
  p_error "Please run WITHOUT sudo"
  p_error "./03-post-install.sh"
  p_br
  exit
fi

read -p "Press enter to continue"

p_h2 "Install yay -S {packages} --needed --noconfirm"
input="./yay-packages.conf"
while IFS='=' read -r lineDesc lineApp
do
  if [[ "$lineDesc" =~ ^[^#].* ]]; then
    if [[ ! -z $lineApp ]]; then
      p_h2 "Install $lineDesc"
      yay -S $lineApp --needed --noconfirm
    fi
  fi
done < "$input"

p_h2 "Install VSCode Extensions"
input="./vscode-extensions.conf"
while IFS= read -r line
do
  if [[ "$line" =~ ^[^#].* ]]; then
    if [[ ! -z $line ]]; then
      p_h2 "vscode.ext = $line"
      code --install-extension $line
    fi
  fi
done < "$input"

p_h2 "Install Java"
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh

jabba install adopt@1.11.0-11
jabba alias default adopt@1.11.0-11


p_h2 "Install Oh My ZSH"
CHSH='yes'
RUNZSH='no' 
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

cp /home/$u/.zshrc /home/$u/.zshrc-bkp
cp .zshrc /home/$u/.zshrc

p_h2 "Install NVM"
echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc
nvm install --lts

p_h2 "Install MVN"

