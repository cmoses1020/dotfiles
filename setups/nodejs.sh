#!/bin/bash
echo "Installing Node.js"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
echo "Sourcing nvm"
\. "$HOME/.nvm/nvm.sh"
echo "Installing Node.js 22"
nvm install 22
echo "Installed Node.js 22"
node -v # Should print "v22.14.0".
nvm current # Should print "v22.14.0".
# Verify npm version:
npm -v # Should print "10.9.2".
