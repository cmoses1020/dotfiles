#!/bin/bash
echo "Installing vim"
sudo apt install vim -y

echo "Installing powerline-status for vim through pip"
pip install powerline-status

echo "Adding powerline to .vimrc"
echo "python3 from powerline.vim import setup as powerline_setup" >> ~/.vimrc
echo "python3 powerline_setup()" >> ~/.vimrc
echo "python3 del powerline_setup" >> ~/.vimrc
# set last status
echo "set laststatus=2" >> ~/.vimrc
