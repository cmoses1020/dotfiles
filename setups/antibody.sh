#!/bin/bash
echo "Installing antibody"
curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
echo "Running antibody bundle"
antibody bundle < ~/Code/dotfiles/zsh/plugins.zsh > ~/Code/dotfiles/zsh/plugins_compiled.zsh
echo "Compiled antibody bundles file"
