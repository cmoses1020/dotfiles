#!/bin/bash

echo "Adding ondrej/php repository"
sudo add-apt-repository ppa:ondrej/php
sudo apt update
echo "Installing php 8.2"
sudo apt install php8.2-{fpm,curl,mbstring,mcrypt,mysql,redis,zip,xml,dom,cli,gd,intl}
