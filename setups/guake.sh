#!/bin/bash
echo "Navigating to Downloads"
cd ~/Downloads
echo "Cloning guake from git"
git clone https://github.com/Guake/guake.git
echo "Installing guake"
cd guake/
./scripts/bootstrap-dev-debian.sh 
make
sudo make install
echo "Cleaning up guake"
cd ..
rm -rf guake
