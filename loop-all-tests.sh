#!/bin/bash
for i in {1..10}; do
    echo "Running test $i..."
    php artisan test --parallel --processes=10 --stop-on-failure --stop-on-error
    if [ $? -ne 0 ]; then
        echo "Test failed on run $i"
    fi
done
