#!/bin/bash
echo "Updating system"
sudo apt update
sudo apt upgrade

echo "Installing apt packages git curl keepass2 pv mysql-server redis gnome-tweaks"
sudo apt install git curl keepass2 pv mysql-server redis gnome-tweaks

echo "Installing snap packages vscode and slack"
sudo snap install slack code

echo "Making home folders"
mkdir ~/Code ~/db_dumps -v

echo "Running setup scripts"
for file in setups/*.sh; do
    echo "Running $file"
    bash $file
done

ZSHRC_CONTENT="
source \$HOME/Code/dotfiles/.zshrc
"

if ! grep -qF "$ZSHRC_CONTENT" ~/.zshrc; then
    echo "Updating .zshrc with dotfiles content"
    echo "$ZSHRC_CONTENT" >> ~/.zshrc
else 
    echo ".zshrc already contains the dotfiles content"
fi
