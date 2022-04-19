# MYSQL
function loadDb() {
    DB=$1
    SQL=$2
    HOST="${3:-127.0.0.1}"
    PORT="${4:-3306}"
    USER="laravel"

    password=$(dialog --insecure --title "LET ME IN" --passwordbox "MYSQL PASSWORD" 16 70 3>&1 1>&2 2>&3 3>&-)
    #Line Break
    mysql -h$HOST -P$PORT -u$USER -p$password -e "drop database if exists $DB; create database $DB;"
    if [ $? -eq 0 ]; then
        if [[ $SQL =~ \.sql.gz$ ]]; then
            (pv -n $SQL | zcat | mysql -h$HOST -P$PORT -u$USER -p$password $DB) 2>&1 | dialog --title "☕Loading $DB database🍺" --gauge "$(fortune)" 16 70
        elif [[ $SQL =~ \.sql$ ]]; then
            (pv -n $SQL | mysql -h$HOST -P$PORT -u$USER -p$password $DB) 2>&1 | dialog --title "☕Loading $DB database🍺" --gauge "$(fortune)" 16 70
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
