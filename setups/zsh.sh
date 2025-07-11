#!/bin/bash



echo "Installing zsh"
sudo apt install zsh

echo "Installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Setting zsh as default shell"
chsh -s $(which zsh)
