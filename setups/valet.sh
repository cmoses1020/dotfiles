#!/bin/bash

echo "Installing required packages for valet"
sudo apt-get install network-manager libnss3-tools jq xsel
echo "Installing valet"
composer global require cpriego/valet-linux
valet install
echo "Parking your Code folder for Valet"
valet park ~/Code
