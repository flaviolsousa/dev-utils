#!/bin/bash

echo "### Manjaro Post Install 02 ###"

u=$(logname)
echo u=$u

if [ "$EUID" -eq 0 ]; then
  echo "Please run WITHOUT sudo"
  echo "./02-post-install.sh"
  exit
fi

read -p "Press enter to continue"

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
CHSH='yes'
RUNZSH='no'
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

cp /home/$u/.zshrc /home/$u/.zshrc-bkp
cp .zshrc /home/$u/.zshrc
