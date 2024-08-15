# Laravel aliases
alias nrd='npm run dev'
alias nrw='guake --split-horizontal && npm run watch'
alias artisan='php artisan'
alias art='php artisan'
alias plz='php please'
alias lreset='rm -rfv ./vendor ./node_modules && composer install && npm ci && art view:clear && npm run dev'
alias composer='COMPOSER_MEMORY_LIMIT=-1 composer'

# SAIL
alias sail='vendor/bin/sail'
alias sart='vendor/bin/sail artisan'

# Require a package from a local folder
composer-link() {
    composer config repositories.local '{"type": "path", "url": "'$1'"}' --file composer.json
}

# Control multiple TMU instances
function tower() {
    php ~/Code/tower/artisan tower:$@
}

# Start a new laravel project with austencam/cable
function newapp() {
    composer create-project --prefer-dist laravel/laravel ${1:-newapp}
    cd ${1:-newapp}
    composer require austencam/cable
    php artisan cable:run
    cp .env.example .env
    php artisan key:generate
}

# Open dev setup for the current project / folder
function dev() {
    cd ~/Code/${1:-$PWD} && code .;
    if [ "$2" = "-w" ]; then
        npm run watch
    fi
}

function createdb() {
    mysql -uroot -e "create database if not exists ${1:laravel};"
}

function share-site() {

    screen -dmS "Vite" npm run dev -- --host=127.0.0.1

    echo "Vite started"

    screen -dmS "art serve" php artisan serve --host=127.0.0.1

    echo "Artisan serve started"

    ngrok http 127.0.0.1:8000

    echo "NGROK closed";

    screen -S "art serve" -X stuff "^C"
    screen -S Vite -X stuff "^C"

    echo "Closed Serve && Vite"
}

function loopTest() {
    if [ -z "$1" ]; then
        echo "Usage: loopTest <test name>"
        return 1
    fi

    # if $2 is set, use that for times run else set to 100
    if [ -z "$2" ]; then
        times=100
    else
        times=$2
    fi

    # loop test until failure or run 100 times
    for i in {1..$times}; do
        echo "Running test $i..."
        vendor/bin/phpunit --filter $1
        if [ $? -ne 0 ]; then
            echo "Test failed on run $i"
            return 1
        fi
    done
}
