#!/bin/bash

source $(dirname $0)/__functions.sh
NOW="$(date +"%Y-%m-%d-%H-%M")"
DUMP_FILE="$1/data/$DB_NAME"_"$NOW.sql"

msg_warn "Backup database..."

MYSQL_CMD="mysqldump -u$DB_USER -p$DB_PASS $DB_NAME"
#echo $MYSQL_CMD
docker exec -it $DB_CONTAINER_NAME sh -c "$MYSQL_CMD" > $DUMP_FILE

msg_info "Done!"
