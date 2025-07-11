#!/bin/bash
echo "Navigating to Downloads"
cd ~/Downloads
echo "Cloning powerline fonts from git"
git clone https://github.com/powerline/fonts.git --depth=1
echo "Installing powerline fonts"
cd fonts
./install.sh
echo "Cleaning up powerline fonts"
cd ..
rm -rf fonts
