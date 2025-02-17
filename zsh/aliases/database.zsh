# MYSQL
## Requires mysql, fortune, pv and dialog
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

function crunchDb() {
    FILENAME=~/db_dumps/$(ls -1t ~/db_dumps/ | grep -P '^'"$1"'(\s\(\d+\))?\.sql\.gz$' | head -n1)
    echo "Crunching $FILENAME and removing audit table"
    pv $FILENAME | zcat | sed -e '/INSERT INTO `audits`/d' -e '/INSERT INTO `health_check_result_history_items`/d' | mysql "$1"
}

function crunchDbNew() {
    # Locate the latest database dump file based on the provided database name prefix
    FILENAME=~/db_dumps/$(ls -1t ~/db_dumps/ | grep -P '^'"$1"'(\s\(\d+\))?\.sql\.gz$' | head -n1)

    # Check if a file was found
    if [[ -z "$FILENAME" ]]; then
        echo "Error: No dump file found for database '$1'."
        return 1
    fi

    echo "Crunching $FILENAME and removing audit and health check tables"

    # Use pv for progress, pigz or zcat for decompression, sed for filtering, and pipe to mysql
    # Redirect stderr from pigz/zcat to null to prevent unwanted output
    if command -v pigz &> /dev/null; then
        pv "$FILENAME" | pigz -dc 2>/dev/null | \
        sed -e '/INSERT INTO `audits`/d' -e '/INSERT INTO `health_check_result_history_items`/d' | \
        mysql "$1"
    else
        pv "$FILENAME" | zcat 2>/dev/null | \
        sed -e '/INSERT INTO `audits`/d' -e '/INSERT INTO `health_check_result_history_items`/d' | \
        mysql "$1"
    fi

    # Check if the MySQL command was successful
    if [[ $? -eq 0 ]]; then
        echo "Database import completed successfully."
    else
        echo "Error: Database import failed."
        return 1
    fi
}

function importDb() {
    FILENAME=~/db_dumps/$(ls -1t ~/db_dumps/ | grep -P '^'"$1"'(\s\(\d+\))?\.sql\.gz$' | head -n1)
    echo "Importing $FILENAME"
    pv $FILENAME | zcat | mysql "$1"
}

function dbSize() {
    DATABASE=$1
    echo "Database size for $DATABASE:"
    mysql -e "SELECT table_schema 'Database', SUM(data_length + index_length) / 1024 / 1024 'Size (MB)' FROM information_schema.tables WHERE table_schema = '$DATABASE' GROUP BY table_schema;"
}

function nukeMysql() {
    # Define color codes
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color
    RADIOACTIVE="☢️"

    # Provide warning and double confirmation for dropping all databases
    echo -e "${RED}${RADIOACTIVE} WARNING: This will drop all databases except MySQL system databases. ${RADIOACTIVE}${NC}"
    
    # First confirmation
    print -n "${RED}Are you sure you want to proceed? (y/n): ${NC}"
    read -r reply1
    echo

    if [[ "$reply1" =~ ^[Yy]$ ]]; then
        # Second confirmation
        print -n "${RED}This action is irreversible. Do you want to continue? (y/n): ${NC}"
        read -r reply2
        echo

        if [[ "$reply2" =~ ^[Yy]$ ]]; then
            echo "Initiating database nuke..."

            # Query non-system databases and delete each one, showing progress
            mysql -N -e "SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys');" | \
            while read -r db; do
                echo -e "${GREEN}Dropping nuke on database: $db${NC}"
                mysql -e "DROP DATABASE \`$db\`;"
            done

            echo "All non-system databases have been dropped."
        else
            echo "Operation cancelled."
        fi
    else
        echo "Operation cancelled."
    fi

}
