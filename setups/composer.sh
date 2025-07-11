#!/bin/bash

echo "Installing composer"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"\nphp -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"\nphp composer-setup.php\nphp -r "unlink('composer-setup.php');"
echo "Moving composer to /usr/local/bin"
sudo mv composer.phar /usr/local/bin/composer\n
echo "Composer installed"
composer -v

ZSHRC_CONTENT="
export PATH=\"\$HOME/.config/composer/vendor/bin:\$PATH\"
"

if ! grep -qF "$ZSHRC_CONTENT" ~/.zshrc; then
    echo "Updating .zshrc with composer export path"
    echo "$ZSHRC_CONTENT" >> ~/.zshrc
else 
    echo ".zshrc already contains the composer export path"
fi
