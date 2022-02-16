# MYSQL
function loadDb() {
    DB=$1
    SQL=$2
    HOST="${3:-127.0.0.1}"
    PORT="${4:-3306}"
    USER="laravel"
    echo -n "Mysql password:"
    read -s password
    #Line Break
    echo ''
    mysql -h$HOST -P$PORT -u$USER -p$password -e "drop database if exists $DB; create database $DB;"
    if [ $? -eq 0 ]; then
        if [[ $SQL =~ \.sql.gz$ ]]; then
            zcat $SQL | mysql -h$HOST -P$PORT -u$USER -p$password $DB
        elif [[ $SQL =~ \.sql$ ]]; then
            mysql -h$HOST -P$PORT -u$USER -p$password $DB < $SQL
        else
            echo "File type is not sql or sql.gz... i am scared"
            return
        fi 

        #notification for when this finishes
        if [ $? -eq 0 ]; then
        notify-send "Database upload for $DB is done"
        else
            notify-send "Database upload for $DB had an issue"
        fi
    else
        echo "Looks like something went wrong, probably a bad password"
    fi
}
