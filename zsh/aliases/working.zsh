function route-update() {
    echo "Pulling latest changes"
    gp
    echo "Checking out tmu-81-get-rid-of-routeserviceprovider-namespace-property"
    gco -b tmu-81-get-rid-of-routeserviceprovider-namespace-property
    
    echo "Removing vendor folder and composer.lock"
    rm composer.lock vendor -rfvv

    echo "Installing composer dependencies"
    composer require hdmaster/core:dev-tmu-81-get-rid-of-routeserviceprovider-namespace-property
    composer install

    # get if .env file exists
    if [ -f .env ]; then
        echo ".env file exists"
    else
        echo ".env file does not exist"
        cp .env.example .env
    fi

    # check if the key is set empty or set to SomeRandomString
    if grep -q "APP_KEY=SomeRandomString" .env; then
        echo "APP_KEY not set"
        php artisan key:generate
    elif grep -q "APP_KEY=" .env; then
        echo "APP_KEY is set"
    else
        echo "APP_KEY is not set"
        php artisan key:generate
    fi

    # if .env DB_DATABASE is set create a database with mysql
    if grep -q "DB_DATABASE=" .env; then
        echo "DB_DATABASE is set"
        DB_DATABASE=$(grep "DB_DATABASE=" .env | cut -d '=' -f 2)
        echo "Creating database $DB_DATABASE"
        mysql -e "create database $DB_DATABASE"
        echo "Creating testing database testing_$DB_DATABASE"
        mysql -e "create database testing_$DB_DATABASE"
    else
        echo "DB_DATABASE is not set"
    fi

    echo "opening code editor"
    code ./ .env app/Providers/RouteServiceProvider.php routes/{web,api,console}.php
}

function pull-upstream() {
    echo "Add upstream bedrock repository"
    git remote add upstream git@github.com:hdmastr/bedrock.git

    echo "pull origin"
    git pull origin main

    echo "pull upstream"
    git pull upstream main

    echo "Removing vendor folder and composer.lock"
    rm composer.lock vendor -rfvv

    echo "Installing composer dependencies"
    composer install
}
